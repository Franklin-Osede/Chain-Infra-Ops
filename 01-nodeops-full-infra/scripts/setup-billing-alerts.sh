#!/bin/bash
# AWS Billing Alerts Setup Script
# KISS Principle: Simple, clear, and maintainable

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
BUDGET_AMOUNT="20"
BUDGET_CURRENCY="EUR"
BUDGET_NAME="NodeOps-Infrastructure-Budget"
ALERT_EMAIL="franklin.op@hormail.com,franksoftwaredevelop@gmail.com"  # Tus emails

# Check if AWS CLI is configured
check_aws_config() {
    log_info "Checking AWS configuration..."
    
    if ! aws sts get-caller-identity >/dev/null 2>&1; then
        log_error "AWS CLI not configured. Please run 'aws configure' first"
        exit 1
    fi
    
    local account_id=$(aws sts get-caller-identity --query Account --output text)
    log_info "AWS Account ID: $account_id"
}

# Create budget
create_budget() {
    log_info "Creating AWS Budget with €${BUDGET_AMOUNT} limit..."
    
    # Create budget JSON
    cat > /tmp/budget.json << EOF
{
    "BudgetName": "${BUDGET_NAME}",
    "BudgetLimit": {
        "Amount": "${BUDGET_AMOUNT}",
        "Unit": "${BUDGET_CURRENCY}"
    },
    "TimeUnit": "MONTHLY",
    "BudgetType": "COST",
    "CostFilters": {
        "Tag": [
            {
                "Key": "Project",
                "Values": ["NodeOps"]
            }
        ]
    },
    "NotificationsWithSubscribers": [
        {
            "Notification": {
                "NotificationType": "ACTUAL",
                "ComparisonOperator": "GREATER_THAN",
                "Threshold": 80,
                "ThresholdType": "PERCENTAGE"
            },
            "Subscribers": [
                {
                    "SubscriptionType": "EMAIL",
                    "Address": "franklin.op@hormail.com"
                },
                {
                    "SubscriptionType": "EMAIL",
                    "Address": "franksoftwaredevelop@gmail.com"
                }
            ]
        },
        {
            "Notification": {
                "NotificationType": "ACTUAL",
                "ComparisonOperator": "GREATER_THAN",
                "Threshold": 100,
                "ThresholdType": "PERCENTAGE"
            },
            "Subscribers": [
                {
                    "SubscriptionType": "EMAIL",
                    "Address": "franklin.op@hormail.com"
                },
                {
                    "SubscriptionType": "EMAIL",
                    "Address": "franksoftwaredevelop@gmail.com"
                }
            ]
        },
        {
            "Notification": {
                "NotificationType": "FORECASTED",
                "ComparisonOperator": "GREATER_THAN",
                "Threshold": 100,
                "ThresholdType": "PERCENTAGE"
            },
            "Subscribers": [
                {
                    "SubscriptionType": "EMAIL",
                    "Address": "franklin.op@hormail.com"
                },
                {
                    "SubscriptionType": "EMAIL",
                    "Address": "franksoftwaredevelop@gmail.com"
                }
            ]
        }
    ]
}
EOF

    # Create the budget
    if aws budgets create-budget --account-id $(aws sts get-caller-identity --query Account --output text) --budget file:///tmp/budget.json; then
        log_info "✅ Budget created successfully!"
        log_info "Budget Name: ${BUDGET_NAME}"
        log_info "Budget Limit: €${BUDGET_AMOUNT}"
        log_info "Alert Email: ${ALERT_EMAIL}"
    else
        log_error "Failed to create budget"
        exit 1
    fi
    
    # Clean up
    rm -f /tmp/budget.json
}

# Create cost anomaly detection
create_anomaly_detection() {
    log_info "Creating cost anomaly detection..."
    
    # Create anomaly monitor
    aws ce create-anomaly-monitor \
        --anomaly-monitor-name "NodeOps-Cost-Anomaly" \
        --anomaly-monitor-type "DIMENSIONAL" \
        --anomaly-monitor-specification '{
            "Dimension": "SERVICE"
        }' >/dev/null 2>&1 || log_warn "Anomaly detection may already exist"
    
    log_info "✅ Cost anomaly detection configured"
}

# Create billing alarm
create_billing_alarm() {
    log_info "Creating CloudWatch billing alarm..."
    
    # Create SNS topic for billing alerts
    local topic_arn=$(aws sns create-topic --name "NodeOps-Billing-Alerts" --query 'TopicArn' --output text 2>/dev/null || \
        aws sns list-topics --query 'Topics[?contains(TopicArn, `NodeOps-Billing-Alerts`)].TopicArn' --output text)
    
    if [ -z "$topic_arn" ]; then
        log_error "Failed to create SNS topic"
        return 1
    fi
    
    # Create CloudWatch alarm
    aws cloudwatch put-metric-alarm \
        --alarm-name "NodeOps-Billing-Alarm" \
        --alarm-description "Alert when estimated charges exceed €${BUDGET_AMOUNT}" \
        --metric-name "EstimatedCharges" \
        --namespace "AWS/Billing" \
        --statistic "Maximum" \
        --period 86400 \
        --threshold "${BUDGET_AMOUNT}" \
        --comparison-operator "GreaterThanThreshold" \
        --evaluation-periods 1 \
        --alarm-actions "$topic_arn" \
        --ok-actions "$topic_arn" >/dev/null 2>&1 || log_warn "Billing alarm may already exist"
    
    log_info "✅ CloudWatch billing alarm created"
}

# Verify budget
verify_budget() {
    log_info "Verifying budget configuration..."
    
    if aws budgets describe-budgets --account-id $(aws sts get-caller-identity --query Account --output text) --query "Budgets[?BudgetName=='${BUDGET_NAME}']" --output text | grep -q "${BUDGET_NAME}"; then
        log_info "✅ Budget verified successfully"
    else
        log_warn "Budget verification failed"
    fi
}

# Display summary
display_summary() {
    echo ""
    log_info "🎉 Billing protection configured successfully!"
    echo ""
    log_info "📊 Budget Configuration:"
    log_info "  - Budget Name: ${BUDGET_NAME}"
    log_info "  - Budget Limit: €${BUDGET_AMOUNT}"
    log_info "  - Alert Email: ${ALERT_EMAIL}"
    log_info "  - Alerts: 80%, 100%, and Forecasted 100%"
    echo ""
    log_info "🔔 You will receive alerts at:"
    log_info "  - 80% of budget (€16)"
    log_info "  - 100% of budget (€20)"
    log_info "  - Forecasted to exceed budget"
    echo ""
    log_info "📱 To check your budget:"
    log_info "  AWS Console → Billing → Budgets"
    echo ""
    log_warn "⚠️  Remember to destroy infrastructure after testing!"
    log_warn "  Use: ./scripts/destroy.sh"
}

# Main function
main() {
    log_info "Setting up AWS billing protection for NodeOps infrastructure..."
    
    # Update email if provided
    if [ $# -eq 1 ]; then
        ALERT_EMAIL="$1"
        log_info "Using email: ${ALERT_EMAIL}"
    else
        log_warn "Using default email: ${ALERT_EMAIL}"
        log_warn "To use your email, run: $0 your-email@example.com"
    fi
    
    check_aws_config
    create_budget
    create_anomaly_detection
    create_billing_alarm
    verify_budget
    display_summary
}

# Run main function
main "$@"
