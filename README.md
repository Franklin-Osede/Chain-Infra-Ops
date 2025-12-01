# Chain Infrastructure Operations

Enterprise-grade blockchain infrastructure platform featuring Kubernetes orchestration, Terraform infrastructure as code, multi-cloud deployment capabilities, and comprehensive monitoring solutions.

**Status**: Work in Progress - Active Development

**AWS Terraform Kubernetes Helm Prometheus Grafana**

## Table of Contents

- [Overview](#overview)
- [Project Status](#project-status)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Development](#development)
- [Deployment](#deployment)
- [Monitoring & Observability](#monitoring--observability)
- [Security](#security)
- [Documentation](#documentation)
- [License](#license)

## Overview

Chain Infrastructure Operations is a work-in-progress blockchain infrastructure platform designed for deploying and managing blockchain nodes at scale. The system consists of six interconnected projects that progressively build upon each other, demonstrating enterprise-grade DevOps practices, infrastructure automation, and cloud-native technologies.

**Note**: This project is currently under active development. Some features and projects are complete, while others are still in progress or planned.

The repository showcases advanced expertise in:

- Infrastructure as Code (Terraform, CloudFormation)
- Container Orchestration (Kubernetes, Helm)
- Multi-Cloud Deployment (AWS, GCP, Azure)
- Monitoring & Observability (Prometheus, Grafana, Loki)
- Security & Identity (Biometric authentication, RBAC)
- Disaster Recovery (Automated failover, backup strategies)

### Key Features

- Kubernetes-based blockchain node orchestration with auto-scaling
- Multi-cloud infrastructure deployment capabilities
- Comprehensive monitoring stack with Prometheus, Grafana, and Loki
- High availability configurations across multiple availability zones
- Disaster recovery automation with automated failover
- Identity and access management with biometric authentication
- Infrastructure as Code with reusable Terraform modules
- Helm chart factory for standardized deployments
- Centralized logging and distributed tracing
- Security-first architecture with zero-trust principles

## Project Status

This repository is a work in progress. Below is the current status of each project:

### Completed

- **01-nodeops-full-infra**: Core infrastructure foundation with Terraform modules, Kubernetes manifests, and Helm charts
  - VPC module implementation
  - EKS cluster configuration
  - Blockchain node Helm chart
  - Monitoring stack Helm chart
  - Basic deployment scripts
  - Architecture and deployment documentation

### In Progress

- **02-helm-chart-factory**: Helm chart repository and management system
- **03-multi-cloud-deployer**: Multi-cloud deployment automation
- **04-multichain-validator-cluster**: High availability validator cluster setup
- **05-blockchain-disaster-recovery**: Disaster recovery automation and failover mechanisms
- **06-identity-gateway**: Identity and access management with biometric authentication

### Planned

- CI/CD pipelines with GitHub Actions
- Additional Terraform modules for GCP and Azure
- Enhanced monitoring dashboards
- Comprehensive testing suite
- Additional blockchain network support
- Advanced security hardening

## Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Cloud                                │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐ │
│  │   Load Balancer │────│   EKS Cluster   │────│   Monitoring    │ │
│  │   (ALB/NLB)    │    │   (Kubernetes) │    │   (Prometheus)  │ │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘ │
│                                │                                │
│                       ┌─────────────────┐                       │
│                       │  Blockchain     │                       │
│                       │  Nodes          │                       │
│                       │  (Ethereum,     │                       │
│                       │   Polygon, etc) │                       │
│                       └─────────────────┘                       │
└─────────────────────────────────────────────────────────────────┘
```

### Component Breakdown

#### Infrastructure Layer (Terraform)

- **VPC**: Isolated network environment with public and private subnets
- **EKS Cluster**: Managed Kubernetes service with auto-scaling node groups
- **Security Groups**: Network access control with least-privilege principles
- **NAT Gateways**: Outbound internet access for private subnets
- **Multi-AZ Deployment**: High availability across availability zones

#### Orchestration Layer (Kubernetes)

- **Namespaces**: Resource isolation for different environments
- **Deployments**: Application lifecycle management with rolling updates
- **Services**: Network service discovery and load balancing
- **Ingress**: External traffic routing with SSL termination
- **ConfigMaps/Secrets**: Configuration and sensitive data management
- **StatefulSets**: Stateful blockchain node deployments
- **Horizontal Pod Autoscaler**: Automatic scaling based on metrics

#### Application Layer (Helm Charts)

- **Blockchain Node Chart**: Ethereum, Polygon, Solana node deployments
- **Monitoring Chart**: Prometheus, Grafana, Loki stack
- **Auto-scaling**: HPA based on CPU and memory metrics
- **Persistent Storage**: EBS volumes for blockchain data

#### Monitoring Layer

- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Loki**: Log aggregation and querying
- **AlertManager**: Alert routing and notification

### Data Flow

#### Traffic Flow
```
Internet → ALB → EKS Ingress → Service → Pod → Blockchain Node
```

#### Monitoring Flow
```
Blockchain Node → Prometheus Exporter → Prometheus → Grafana
                ↓
                Loki (Logs) → Grafana
```

#### Configuration Flow
```
Terraform → EKS Cluster → Helm Charts → Kubernetes Resources
```

## Project Structure

```
chain-infra-ops/
├── 01-nodeops-full-infra/          # Infrastructure Foundation
│   ├── terraform/                   # Infrastructure as Code
│   │   ├── modules/                 # Reusable Terraform modules
│   │   │   └── vpc/                 # VPC module
│   │   └── environments/            # Environment-specific configs
│   │       ├── dev/                 # Development environment
│   │       ├── staging/             # Staging environment
│   │       └── prod/                # Production environment
│   ├── kubernetes/                  # Kubernetes manifests
│   │   ├── helm-charts/             # Helm chart definitions
│   │   │   ├── blockchain-node/     # Blockchain node chart
│   │   │   └── monitoring/          # Monitoring stack chart
│   │   └── manifests/               # Raw Kubernetes manifests
│   ├── monitoring/                  # Monitoring configuration
│   │   ├── prometheus/              # Prometheus alerts and rules
│   │   ├── grafana/                 # Grafana dashboards
│   │   └── loki/                    # Loki configuration
│   ├── scripts/                     # Deployment scripts
│   │   ├── deploy.sh                # Infrastructure deployment
│   │   ├── destroy.sh               # Infrastructure teardown
│   │   └── setup-billing-alerts.sh  # Cost monitoring setup
│   ├── docs/                        # Project documentation
│   │   ├── architecture.md          # Architecture documentation
│   │   └── deployment.md            # Deployment guide
│   └── Makefile                     # Build automation
│
├── 02-helm-chart-factory/           # Helm Chart Management
│   └── README.md                    # Chart factory documentation
│
├── 03-multi-cloud-deployer/         # Multi-Cloud Deployment
│
├── 04-multichain-validator-cluster/ # High Availability Validators
│
├── 05-blockchain-disaster-recovery/ # Disaster Recovery Automation
│
├── 06-identity-gateway/             # Security & Authentication
│
├── shared/                          # Shared resources
│   ├── helm-charts/                 # Shared Helm charts
│   ├── scripts/                     # Shared automation scripts
│   └── terraform-modules/           # Shared Terraform modules
│
├── docs/                            # Global documentation
│   ├── adr/                         # Architecture Decision Records
│   ├── api/                         # API documentation
│   └── deployment/                  # Deployment guides
│
├── Makefile                         # Root build automation
└── README.md                        # This file
```

## Technology Stack

### Infrastructure

- **Terraform** (>= 1.5) - Infrastructure as Code
- **Kubernetes** (>= 1.28) - Container orchestration
- **Helm** (>= 3.18) - Package management
- **Docker** - Containerization

### Cloud Providers

- **AWS** - Primary cloud platform (EKS, VPC, EBS, ALB)
- **GCP** - Multi-cloud support
- **Azure** - Enterprise integration

### Monitoring & Observability

- **Prometheus** - Metrics collection and storage
- **Grafana** - Visualization and dashboards
- **Loki** - Log aggregation
- **AlertManager** - Alert routing and notification
- **CloudWatch** - AWS-native monitoring

### Security

- **AWS Secrets Manager** - Secrets management
- **RBAC** - Role-based access control
- **Network Policies** - Pod-to-pod traffic control
- **Pod Security Standards** - Security contexts
- **Vault** - Secrets management (optional)

### Blockchain Networks

- **Ethereum** - Full node support
- **Polygon** - Polygon node support
- **Solana** - Validator node support
- **Multi-chain** - Support for multiple blockchain networks

## Getting Started

### Prerequisites

- **Terraform** >= 1.5
- **kubectl** >= 1.28
- **Helm** >= 3.18
- **AWS CLI** >= 2.0
- **Docker** (for local development)
- **Git** (for version control)
- **AWS Account** with appropriate permissions

### Installation

```bash
# Clone the repository
git clone https://github.com/Franklin-Osede/chain-infra-ops.git
cd chain-infra-ops

# Verify prerequisites
make setup
```

### Environment Setup

#### AWS Configuration

```bash
# Configure AWS CLI
aws configure

# Verify AWS access
aws sts get-caller-identity

# Set AWS region (optional)
export AWS_DEFAULT_REGION=us-west-2
```

#### Terraform Configuration

```bash
# Navigate to project directory
cd 01-nodeops-full-infra

# Initialize Terraform
cd terraform/environments/dev
terraform init
```

### Quick Start Deployment

```bash
# Deploy complete infrastructure
make deploy

# Or deploy step by step
cd 01-nodeops-full-infra
make setup
make deploy
make monitor
```

## Development

### Local Development

#### Infrastructure Development

```bash
# Navigate to infrastructure project
cd 01-nodeops-full-infra

# Plan infrastructure changes
cd terraform/environments/dev
terraform plan

# Apply changes
terraform apply

# Format Terraform code
terraform fmt
```

#### Kubernetes Development

```bash
# Configure kubectl for EKS cluster
aws eks update-kubeconfig --region us-west-2 --name nodeops-dev

# Verify cluster access
kubectl get nodes

# Deploy Helm charts locally
helm upgrade --install blockchain-node kubernetes/helm-charts/blockchain-node \
  --namespace blockchain \
  --create-namespace
```

#### Helm Chart Development

```bash
# Lint Helm charts
helm lint kubernetes/helm-charts/blockchain-node

# Template Helm charts (dry-run)
helm template blockchain-node kubernetes/helm-charts/blockchain-node

# Test Helm charts
helm test blockchain-node
```

### Testing

```bash
# Run all tests
make test

# Run Terraform validation
terraform validate

# Run Helm linting
helm lint kubernetes/helm-charts/*

# Format code
make format
```

### Code Quality

```bash
# Run linting
make lint

# Format code
make format

# Clean temporary files
make clean
```

## Deployment

### Infrastructure Deployment

#### Development Environment

```bash
cd 01-nodeops-full-infra/terraform/environments/dev

# Initialize Terraform
terraform init

# Review changes
terraform plan

# Apply infrastructure
terraform apply
```

#### Production Environment

```bash
cd 01-nodeops-full-infra/terraform/environments/prod

# Initialize Terraform
terraform init

# Review changes carefully
terraform plan

# Apply with confirmation
terraform apply
```

### Application Deployment

#### Deploy Monitoring Stack

```bash
# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy monitoring stack
helm upgrade --install monitoring \
  kubernetes/helm-charts/monitoring \
  --namespace monitoring \
  --create-namespace \
  --values kubernetes/helm-charts/monitoring/values.yaml
```

#### Deploy Blockchain Node

```bash
# Deploy blockchain node
helm upgrade --install blockchain-node \
  kubernetes/helm-charts/blockchain-node \
  --namespace blockchain \
  --create-namespace \
  --values kubernetes/helm-charts/blockchain-node/values.yaml
```

### Deployment Verification

```bash
# Check infrastructure
kubectl get nodes
kubectl get namespaces
kubectl get pods --all-namespaces

# Check applications
kubectl get pods -n monitoring
kubectl get pods -n blockchain
kubectl get services --all-namespaces

# Check Helm releases
helm list --all-namespaces
```

### Rollback Procedures

```bash
# Rollback Helm release
helm rollback blockchain-node 1

# Rollback Terraform changes
terraform plan -destroy
terraform apply -target=module.eks
```

## Monitoring & Observability

### CloudWatch Dashboards

Access dashboards via AWS Console:

- **EKS Cluster Metrics**: Node count, CPU/memory utilization
- **Application Metrics**: Pod status, resource usage
- **Network Metrics**: Traffic patterns, latency
- **Cost Metrics**: Resource costs and billing alerts

### Prometheus Metrics

```bash
# Port forward to Prometheus
kubectl port-forward -n monitoring svc/monitoring-prometheus-server 9090:80

# Access Prometheus UI
# http://localhost:9090
```

Available metrics:

- **Infrastructure**: CPU, Memory, Disk, Network
- **Application**: Response time, error rate, throughput
- **Blockchain**: Block height, sync status, peer count

### Grafana Dashboards

```bash
# Port forward to Grafana
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80

# Access Grafana UI
# http://localhost:3000
# Default credentials: admin/admin
```

Pre-configured dashboards:

- **Blockchain Node Dashboard**: Node health, sync status, performance
- **Kubernetes Cluster Dashboard**: Cluster resources and utilization
- **Application Dashboard**: Application metrics and logs

### Logging

#### View Application Logs

```bash
# View pod logs
kubectl logs -n blockchain deployment/blockchain-node

# Follow logs
kubectl logs -n blockchain deployment/blockchain-node -f

# View logs from all pods
kubectl logs -n blockchain -l app=blockchain-node
```

#### View Loki Logs

```bash
# Port forward to Loki
kubectl port-forward -n monitoring svc/loki 3100:3100

# Query logs via Grafana
# Navigate to Grafana → Explore → Select Loki data source
```

### Alerting

Configured alerts notify when:

- **Critical**: Service down, pod failures, node failures
- **Warning**: High resource usage, slow response times
- **Info**: Deployment events, scaling events

Alert destinations:

- **Email**: Configured via AlertManager
- **Slack**: Optional integration
- **PagerDuty**: Optional integration

## Security

### Network Security

- **VPC Isolation**: Private subnets for EKS nodes
- **Security Groups**: Least-privilege firewall rules
- **Network Policies**: Pod-to-pod communication control
- **Private Endpoints**: VPC endpoints for AWS services

### Application Security

- **RBAC**: Role-based access control for Kubernetes
- **Pod Security Standards**: Security contexts and policies
- **Secrets Management**: Kubernetes secrets and AWS Secrets Manager
- **Image Scanning**: Container image vulnerability scanning

### Data Protection

- **Encryption at Rest**: EBS volume encryption
- **Encryption in Transit**: TLS for all communications
- **Secrets Encryption**: KMS encryption for sensitive data
- **Backup Encryption**: Encrypted backups for disaster recovery

### Access Control

- **IAM Roles**: Least-privilege access for EKS tasks
- **Service Accounts**: Kubernetes service account management
- **Multi-Factor Authentication**: MFA for AWS console access
- **Audit Logging**: CloudTrail for all API calls

### Compliance

- **Security Best Practices**: Following AWS Well-Architected Framework
- **Audit Trail**: Complete audit logging in CloudTrail
- **Compliance Ready**: Architecture supports various compliance requirements

## Documentation

### Project Documentation

Each project includes comprehensive documentation:

- **[Architecture Guide](./01-nodeops-full-infra/docs/architecture.md)** - System design and patterns
- **[Deployment Guide](./01-nodeops-full-infra/docs/deployment.md)** - Step-by-step deployment instructions
- **[API Documentation](./docs/api/)** - Service interfaces and APIs
- **[Troubleshooting](./docs/troubleshooting.md)** - Common issues and solutions

### Development Guides

- **Terraform Modules**: Reusable infrastructure components
- **Helm Charts**: Application deployment templates
- **Kubernetes Manifests**: Raw Kubernetes resource definitions
- **Monitoring Setup**: Prometheus, Grafana, and Loki configuration

### Infrastructure Guides

- **VPC Configuration**: Network architecture and design
- **EKS Setup**: Kubernetes cluster configuration
- **Security Hardening**: Security best practices
- **Cost Optimization**: Resource optimization strategies

## Design Philosophy

### KISS Principle

Keep It Simple, Stupid

- Clean, maintainable infrastructure code
- Minimal complexity
- Clear documentation
- Easy to understand and modify

### SOLID Principles

- **Single Responsibility**: Each module has one purpose
- **Open/Closed**: Extensible without modification
- **Liskov Substitution**: Interchangeable components
- **Interface Segregation**: Focused interfaces
- **Dependency Inversion**: Abstractions over concretions

### DRY & YAGNI

- **DRY**: Don't Repeat Yourself - Reusable modules and components
- **YAGNI**: You Aren't Gonna Need It - Only implement what's needed

## Contributing

This is an open-source project. Contributions are welcome!

### Development Workflow

```bash
# Fork the repository
git clone https://github.com/your-username/chain-infra-ops.git

# Create a feature branch
git checkout -b feature/amazing-feature

# Make your changes
# Add tests
# Update documentation

# Commit your changes
git commit -m "Add amazing feature"

# Push to your fork
git push origin feature/amazing-feature

# Create a Pull Request
```

### Contribution Guidelines

- Follow the existing code style and conventions
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting
- Write clear commit messages

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Acknowledgments

- **HashiCorp** for Terraform and infrastructure tooling
- **Kubernetes Community** for orchestration tools and best practices
- **Prometheus Team** for monitoring solutions
- **Open Source Community** for inspiration and support

## Contact

- **GitHub**: [@Franklin-Osede](https://github.com/Franklin-Osede)
- **Email**: franklin.op@hormail.com
- **LinkedIn**: [Franklin Osede](https://linkedin.com/in/franklin-osede)

---

Built for the blockchain infrastructure community
