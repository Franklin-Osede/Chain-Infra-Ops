#!/bin/bash
# NodeOps Full Infrastructure - Deployment Script
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

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v terraform &> /dev/null; then
        log_error "Terraform is not installed"
        exit 1
    fi
    
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed"
        exit 1
    fi
    
    if ! command -v helm &> /dev/null; then
        log_error "Helm is not installed"
        exit 1
    fi
    
    log_info "All prerequisites are met"
}

# Deploy infrastructure
deploy_infrastructure() {
    log_info "Deploying infrastructure..."
    
    cd terraform/environments/dev
    
    # Initialize Terraform
    log_info "Initializing Terraform..."
    terraform init
    
    # Plan deployment
    log_info "Planning deployment..."
    terraform plan -out=tfplan
    
    # Apply deployment
    log_info "Applying deployment..."
    terraform apply tfplan
    
    log_info "Infrastructure deployed successfully"
}

# Configure kubectl
configure_kubectl() {
    log_info "Configuring kubectl..."
    
    # Get cluster name from Terraform output
    CLUSTER_NAME=$(terraform output -raw cluster_id)
    AWS_REGION=$(terraform output -raw aws_region)
    
    # Update kubeconfig
    aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"
    
    log_info "kubectl configured successfully"
}

# Deploy monitoring stack
deploy_monitoring() {
    log_info "Deploying monitoring stack..."
    
    # Add Helm repositories
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    
    # Deploy monitoring stack
    helm upgrade --install monitoring kubernetes/helm-charts/monitoring \
        --namespace monitoring \
        --create-namespace \
        --values kubernetes/helm-charts/monitoring/values.yaml
    
    log_info "Monitoring stack deployed successfully"
}

# Deploy blockchain node
deploy_blockchain_node() {
    log_info "Deploying blockchain node..."
    
    # Deploy blockchain node
    helm upgrade --install blockchain-node kubernetes/helm-charts/blockchain-node \
        --namespace blockchain \
        --create-namespace \
        --values kubernetes/helm-charts/blockchain-node/values.yaml
    
    log_info "Blockchain node deployed successfully"
}

# Main deployment function
main() {
    log_info "Starting NodeOps Full Infrastructure deployment..."
    
    check_prerequisites
    deploy_infrastructure
    configure_kubectl
    deploy_monitoring
    deploy_blockchain_node
    
    log_info "Deployment completed successfully!"
    log_info "Access monitoring at: kubectl port-forward svc/monitoring-grafana 3000:80"
    log_info "Access Prometheus at: kubectl port-forward svc/monitoring-prometheus-server 9090:80"
}

# Run main function
main "$@"
