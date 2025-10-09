# NodeOps Full Infrastructure - Deployment Guide

## 🚀 Quick Start

### Prerequisites

Before deploying, ensure you have:

- **AWS CLI** configured with appropriate permissions
- **Terraform** >= 1.0 installed
- **kubectl** configured for EKS
- **Helm** >= 3.0 installed
- **Docker** for container builds

### 1. Environment Setup

```bash
# Clone the repository
git clone <repository-url>
cd chain-infra-ops/01-nodeops-full-infra

# Setup development environment
make setup
```

### 2. AWS Configuration

```bash
# Configure AWS CLI (you'll need your credentials here)
aws configure

# Verify AWS access
aws sts get-caller-identity
```

**🔑 CREDENTIALS NEEDED**: 
- AWS Access Key ID
- AWS Secret Access Key
- AWS Region (default: us-west-2)

### 3. Deploy Infrastructure

```bash
# Deploy complete infrastructure
make deploy

# Or step by step:
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### 4. Configure kubectl

```bash
# Update kubeconfig for EKS cluster
aws eks update-kubeconfig --region us-west-2 --name nodeops-dev

# Verify cluster access
kubectl get nodes
```

### 5. Deploy Applications

```bash
# Deploy monitoring stack
helm upgrade --install monitoring kubernetes/helm-charts/monitoring \
  --namespace monitoring \
  --create-namespace

# Deploy blockchain node
helm upgrade --install blockchain-node kubernetes/helm-charts/blockchain-node \
  --namespace blockchain \
  --create-namespace
```

## 📋 Detailed Deployment Steps

### Step 1: Infrastructure Deployment

#### 1.1 VPC and Networking
```bash
cd terraform/environments/dev
terraform apply -target=module.vpc
```

#### 1.2 EKS Cluster
```bash
terraform apply -target=module.eks
```

#### 1.3 Security Groups
```bash
terraform apply -target=aws_security_group.nodeops
```

### Step 2: Application Deployment

#### 2.1 Monitoring Stack
```bash
# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy monitoring
helm upgrade --install monitoring kubernetes/helm-charts/monitoring \
  --namespace monitoring \
  --create-namespace \
  --values kubernetes/helm-charts/monitoring/values.yaml
```

#### 2.2 Blockchain Node
```bash
# Deploy blockchain node
helm upgrade --install blockchain-node kubernetes/helm-charts/blockchain-node \
  --namespace blockchain \
  --create-namespace \
  --values kubernetes/helm-charts/blockchain-node/values.yaml
```

### Step 3: Verification

#### 3.1 Check Infrastructure
```bash
# Check EKS cluster
kubectl get nodes

# Check namespaces
kubectl get namespaces

# Check pods
kubectl get pods --all-namespaces
```

#### 3.2 Check Applications
```bash
# Check monitoring
kubectl get pods -n monitoring

# Check blockchain node
kubectl get pods -n blockchain

# Check services
kubectl get services --all-namespaces
```

## 🔧 Configuration Options

### Environment Variables

#### Development Environment
```bash
export TF_VAR_environment=dev
export TF_VAR_aws_region=us-west-2
export TF_VAR_node_instance_types='["t3.medium"]'
export TF_VAR_node_min_size=1
export TF_VAR_node_max_size=3
```

#### Production Environment
```bash
export TF_VAR_environment=prod
export TF_VAR_aws_region=us-west-2
export TF_VAR_node_instance_types='["t3.large","t3.xlarge"]'
export TF_VAR_node_min_size=3
export TF_VAR_node_max_size=10
```

### Helm Values Customization

#### Blockchain Node Configuration
```yaml
# kubernetes/helm-charts/blockchain-node/values.yaml
image:
  repository: "ethereum/client-go"
  tag: "latest"

resources:
  requests:
    memory: "2Gi"
    cpu: "1000m"
  limits:
    memory: "4Gi"
    cpu: "2000m"

persistence:
  enabled: true
  size: "200Gi"
```

#### Monitoring Configuration
```yaml
# kubernetes/helm-charts/monitoring/values.yaml
prometheus:
  enabled: true
  server:
    persistentVolume:
      enabled: true
      size: 50Gi

grafana:
  enabled: true
  adminPassword: "secure-password"
  persistence:
    enabled: true
    size: 10Gi
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Terraform State Issues
```bash
# Reinitialize Terraform
terraform init -upgrade

# Check state
terraform state list

# Import existing resources if needed
terraform import aws_vpc.main vpc-xxxxxxxxx
```

#### 2. EKS Cluster Access Issues
```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-west-2 --name nodeops-dev

# Check cluster status
aws eks describe-cluster --name nodeops-dev --region us-west-2
```

#### 3. Helm Chart Issues
```bash
# Check Helm repositories
helm repo list

# Update repositories
helm repo update

# Check chart dependencies
helm dependency update kubernetes/helm-charts/monitoring
```

#### 4. Pod Startup Issues
```bash
# Check pod logs
kubectl logs -n blockchain deployment/blockchain-node

# Check pod events
kubectl describe pod -n blockchain <pod-name>

# Check resource usage
kubectl top pods --all-namespaces
```

### Monitoring Access

#### Grafana Dashboard
```bash
# Port forward to Grafana
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80

# Access: http://localhost:3000
# Username: admin
# Password: admin123 (or your configured password)
```

#### Prometheus
```bash
# Port forward to Prometheus
kubectl port-forward -n monitoring svc/monitoring-prometheus-server 9090:80

# Access: http://localhost:9090
```

## 🔄 Updates and Maintenance

### Infrastructure Updates
```bash
# Plan changes
terraform plan

# Apply changes
terraform apply

# Check for drift
terraform plan -detailed-exitcode
```

### Application Updates
```bash
# Update Helm charts
helm upgrade blockchain-node kubernetes/helm-charts/blockchain-node

# Rollback if needed
helm rollback blockchain-node 1
```

### Monitoring Updates
```bash
# Update monitoring stack
helm upgrade monitoring kubernetes/helm-charts/monitoring

# Check monitoring status
kubectl get pods -n monitoring
```

## 🧹 Cleanup

### Destroy Infrastructure
```bash
# Destroy applications first
helm uninstall blockchain-node -n blockchain
helm uninstall monitoring -n monitoring

# Destroy infrastructure
terraform destroy
```

### Cleanup Resources
```bash
# Clean up local files
make clean

# Remove kubectl context
kubectl config delete-context arn:aws:eks:us-west-2:account:cluster/nodeops-dev
```
