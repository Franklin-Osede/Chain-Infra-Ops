#!/bin/bash
# NodeOps Full Infrastructure - Destruction Script
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

# Confirmation function
confirm_destroy() {
    echo -e "${RED}⚠️  WARNING: This will DESTROY ALL infrastructure! ⚠️${NC}"
    echo -e "${YELLOW}This includes:${NC}"
    echo "  - EKS Cluster"
    echo "  - VPC and subnets"
    echo "  - Security Groups"
    echo "  - Load Balancers"
    echo "  - All Kubernetes resources"
    echo ""
    read -p "Are you sure you want to continue? (type 'yes' to confirm): " confirmation
    
    if [ "$confirmation" != "yes" ]; then
        log_info "Destruction cancelled"
        exit 0
    fi
}

# Destroy Kubernetes resources
destroy_kubernetes() {
    log_info "Destroying Kubernetes resources..."
    
    # Delete Helm releases
    if helm list --all-namespaces | grep -q "monitoring\|blockchain-node"; then
        log_info "Uninstalling Helm releases..."
        helm uninstall monitoring -n monitoring 2>/dev/null || true
        helm uninstall blockchain-node -n blockchain 2>/dev/null || true
    fi
    
    # Delete namespaces
    if kubectl get namespaces | grep -q "monitoring\|blockchain"; then
        log_info "Deleting namespaces..."
        kubectl delete namespace monitoring 2>/dev/null || true
        kubectl delete namespace blockchain 2>/dev/null || true
    fi
    
    log_info "Kubernetes resources destroyed"
}

# Destroy Terraform infrastructure
destroy_terraform() {
    log_info "Destroying Terraform infrastructure..."
    
    cd terraform/environments/dev
    
    # Initialize if needed
    if [ ! -d ".terraform" ]; then
        log_info "Initializing Terraform..."
        terraform init
    fi
    
    # Destroy infrastructure
    log_info "Running terraform destroy..."
    terraform destroy -auto-approve
    
    log_info "Terraform infrastructure destroyed"
}

# Verify destruction
verify_destruction() {
    log_info "Verifying destruction..."
    
    # Check EKS clusters
    if aws eks list-clusters --query 'clusters[?contains(name, `nodeops`)]' --output text 2>/dev/null | grep -q "nodeops"; then
        log_warn "EKS cluster still exists"
    else
        log_info "✅ EKS cluster destroyed"
    fi
    
    # Check EC2 instances
    instances=$(aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name!=`terminated`].[InstanceId]' --output text 2>/dev/null | wc -l)
    if [ "$instances" -gt 0 ]; then
        log_warn "Some EC2 instances still exist"
    else
        log_info "✅ No EC2 instances found"
    fi
    
    # Check VPCs (excluding default)
    vpcs=$(aws ec2 describe-vpcs --query 'Vpcs[?IsDefault==`false`].[VpcId]' --output text 2>/dev/null | wc -l)
    if [ "$vpcs" -gt 0 ]; then
        log_warn "Some VPCs still exist"
    else
        log_info "✅ No custom VPCs found"
    fi
}

# Clean up local files
cleanup_local() {
    log_info "Cleaning up local files..."
    
    # Remove Terraform state
    find . -name "*.tfstate*" -delete 2>/dev/null || true
    find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
    
    # Remove kubeconfig entries
    kubectl config delete-context $(kubectl config current-context) 2>/dev/null || true
    
    log_info "Local files cleaned up"
}

# Main destruction function
main() {
    log_info "Starting NodeOps Full Infrastructure destruction..."
    
    confirm_destroy
    
    destroy_kubernetes
    destroy_terraform
    verify_destruction
    cleanup_local
    
    log_info "🎉 Destruction completed successfully!"
    log_info "All infrastructure has been destroyed"
    log_info "No AWS resources should remain"
    
    echo ""
    log_info "Next steps:"
    log_info "1. Check AWS Console to verify all resources are gone"
    log_info "2. Check AWS Cost Explorer for any remaining charges"
    log_info "3. Set up billing alerts for future deployments"
}

# Run main function
main "$@"
