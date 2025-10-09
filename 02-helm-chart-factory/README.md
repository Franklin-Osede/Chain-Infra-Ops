# Helm Chart Factory

A public repository of reusable Helm Charts for blockchain infrastructure.

## 🎯 Overview

This project provides a comprehensive collection of Helm Charts for deploying blockchain nodes and related infrastructure components. All charts are production-ready, well-documented, and follow Kubernetes best practices.

## 📦 Available Charts

| Chart | Description | Version | Status |
|-------|-------------|---------|--------|
| [ethereum-node](./charts/ethereum-node/) | Ethereum full node | 0.1.0 | ✅ Stable |
| [polygon-node](./charts/polygon-node/) | Polygon full node | 0.1.0 | ✅ Stable |
| [solana-node](./charts/solana-node/) | Solana validator node | 0.1.0 | ✅ Stable |
| [blockchain-monitoring](./charts/blockchain-monitoring/) | Monitoring stack | 0.1.0 | ✅ Stable |
| [blockchain-loadbalancer](./charts/blockchain-loadbalancer/) | Load balancer for nodes | 0.1.0 | ✅ Stable |

## 🚀 Quick Start

### Add Repository

```bash
helm repo add blockchain-charts https://your-username.github.io/helm-chart-factory
helm repo update
```

### Install a Chart

```bash
# Install Ethereum node
helm install ethereum-node blockchain-charts/ethereum-node

# Install with custom values
helm install ethereum-node blockchain-charts/ethereum-node \
  --values custom-values.yaml
```

## 🔧 Development

### Prerequisites

- Helm 3.x
- Kubernetes cluster
- Docker (for testing)

### Local Development

```bash
# Clone repository
git clone <repo-url>
cd helm-chart-factory

# Lint charts
make lint

# Test charts
make test

# Package charts
make package
```

## 📚 Documentation

- [Chart Development Guide](./docs/development.md)
- [Contributing Guidelines](./docs/contributing.md)
- [Release Process](./docs/release.md)

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Pages  │────│   Helm Charts   │────│   Kubernetes    │
│   (Documentation)│    │   (Repository)   │    │   (Deployment)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                       ┌─────────────────┐
                       │   CI/CD Pipeline│
                       │   (GitHub Actions)│
                       └─────────────────┘
```

## 🎯 Design Principles

- **KISS**: Simple, maintainable charts
- **SOLID**: Modular, reusable components
- **DRY**: No code duplication
- **YAGNI**: Only what's needed

## 📄 License

MIT License - see [LICENSE](./LICENSE) file for details.
