# NodeOps Full Infrastructure - Makefile
# KISS Principle: Simple, clear, and maintainable

.PHONY: help setup deploy destroy monitor test lint format clean

# Default target
help: ## Show this help message
	@echo "NodeOps Full Infrastructure"
	@echo "=========================="
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Setup development environment
	@echo "Setting up NodeOps Full Infrastructure..."
	@terraform --version
	@kubectl version --client
	@helm version
	@echo "✓ Environment ready"

deploy: ## Deploy infrastructure
	@echo "Deploying infrastructure..."
	@cd terraform/environments/dev && terraform init
	@cd terraform/environments/dev && terraform plan
	@cd terraform/environments/dev && terraform apply -auto-approve
	@echo "✓ Infrastructure deployed"

destroy: ## Destroy infrastructure
	@echo "Destroying infrastructure..."
	@cd terraform/environments/dev && terraform destroy -auto-approve
	@echo "✓ Infrastructure destroyed"

monitor: ## Start monitoring dashboard
	@echo "Starting monitoring dashboard..."
	@kubectl port-forward svc/grafana 3000:80 &
	@kubectl port-forward svc/prometheus 9090:80 &
	@echo "✓ Monitoring available at:"
	@echo "  - Grafana: http://localhost:3000"
	@echo "  - Prometheus: http://localhost:9090"

test: ## Run tests
	@echo "Running tests..."
	@terraform fmt -check terraform/
	@helm lint kubernetes/helm-charts/*
	@echo "✓ Tests passed"

lint: ## Run linting
	@echo "Running linting..."
	@terraform fmt -check terraform/
	@helm lint kubernetes/helm-charts/*
	@echo "✓ Linting passed"

format: ## Format code
	@echo "Formatting code..."
	@terraform fmt terraform/
	@echo "✓ Code formatted"

clean: ## Clean temporary files
	@echo "Cleaning temporary files..."
	@find . -name "*.tfstate*" -delete
	@find . -name ".terraform" -type d -exec rm -rf {} +
	@echo "✓ Cleaned"
