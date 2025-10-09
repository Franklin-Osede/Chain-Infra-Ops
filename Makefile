# Chain Infrastructure Operations - Main Makefile
# KISS Principle: Simple, clear, and maintainable

.PHONY: help setup clean test lint format

# Default target
help: ## Show this help message
	@echo "Chain Infrastructure Operations"
	@echo "=============================="
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Setup development environment
	@echo "Setting up development environment..."
	@if command -v terraform >/dev/null 2>&1; then echo "✓ Terraform found"; else echo "✗ Install Terraform"; fi
	@if command -v kubectl >/dev/null 2>&1; then echo "✓ kubectl found"; else echo "✗ Install kubectl"; fi
	@if command -v helm >/dev/null 2>&1; then echo "✓ Helm found"; else echo "✗ Install Helm"; fi
	@if command -v docker >/dev/null 2>&1; then echo "✓ Docker found"; else echo "✗ Install Docker"; fi

clean: ## Clean temporary files
	@echo "Cleaning temporary files..."
	@find . -name "*.tfstate*" -delete
	@find . -name ".terraform" -type d -exec rm -rf {} +
	@find . -name "*.log" -delete
	@find . -name ".DS_Store" -delete

test: ## Run tests across all projects
	@echo "Running tests..."
	@for project in */; do \
		if [ -f "$$project/Makefile" ]; then \
			echo "Testing $$project"; \
			$(MAKE) -C "$$project" test || exit 1; \
		fi; \
	done

lint: ## Run linting across all projects
	@echo "Running linting..."
	@for project in */; do \
		if [ -f "$$project/Makefile" ]; then \
			echo "Linting $$project"; \
			$(MAKE) -C "$$project" lint || exit 1; \
		fi; \
	done

format: ## Format code across all projects
	@echo "Formatting code..."
	@for project in */; do \
		if [ -f "$$project/Makefile" ]; then \
			echo "Formatting $$project"; \
			$(MAKE) -C "$$project" format || exit 1; \
		fi; \
	done

# Project-specific targets
nodeops: ## Work on NodeOps Full Infra project
	@echo "Working on NodeOps Full Infra..."
	@cd 01-nodeops-full-infra && $(MAKE) help

helm-factory: ## Work on Helm Chart Factory project
	@echo "Working on Helm Chart Factory..."
	@cd 02-helm-chart-factory && $(MAKE) help

multi-cloud: ## Work on Multi-Cloud Deployer project
	@echo "Working on Multi-Cloud Deployer..."
	@cd 03-multi-cloud-deployer && $(MAKE) help

validator-cluster: ## Work on Multichain Validator Cluster project
	@echo "Working on Multichain Validator Cluster..."
	@cd 04-multichain-validator-cluster && $(MAKE) help

disaster-recovery: ## Work on Blockchain Disaster Recovery project
	@echo "Working on Blockchain Disaster Recovery..."
	@cd 05-blockchain-disaster-recovery && $(MAKE) help

identity-gateway: ## Work on Identity Gateway project
	@echo "Working on Identity Gateway..."
	@cd 06-identity-gateway && $(MAKE) help
