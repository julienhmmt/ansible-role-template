.PHONY: help lint test converge verify destroy reset install-deps venv login idempotence

MOLECULE_SCENARIO ?= default
VENV_DIR ?= .venv
PYTHON := $(VENV_DIR)/bin/python
PIP := $(VENV_DIR)/bin/pip

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

venv: ## Create Python virtual environment and source it
	@if [ ! -d "$(VENV_DIR)" ]; then \
		python3 -m venv $(VENV_DIR); \
	else \
		echo "Virtual environment already exists at $(VENV_DIR)"; \
	fi
	@echo "source $(VENV_DIR)/bin/activate"

install-deps: venv ## Install Python test dependencies
	$(PIP) install -r requirements-dev.txt

lint: ## Run yamllint + ansible-lint
	$(VENV_DIR)/bin/yamllint .
	$(VENV_DIR)/bin/ansible-lint

test: ## Full Molecule cycle (create → converge → verify → destroy)
	$(VENV_DIR)/bin/molecule test -s $(MOLECULE_SCENARIO)

converge: ## Deploy the role in the container (without destroy)
	$(VENV_DIR)/bin/molecule converge -s $(MOLECULE_SCENARIO)

verify: ## Run verification assertions
	$(VENV_DIR)/bin/molecule verify -s $(MOLECULE_SCENARIO)

login: ## Open a shell in the test container
	$(VENV_DIR)/bin/molecule login -s $(MOLECULE_SCENARIO)

destroy: ## Remove the test container
	$(VENV_DIR)/bin/molecule destroy -s $(MOLECULE_SCENARIO)

reset: ## Destroy + remove built images
	$(VENV_DIR)/bin/molecule destroy -s $(MOLECULE_SCENARIO)
	@docker images --format '{{.Repository}}:{{.Tag}}' | grep molecule- | xargs -r docker rmi -f 2>/dev/null || true

idempotence: ## Converge twice to test idempotence
	$(VENV_DIR)/bin/molecule converge -s $(MOLECULE_SCENARIO)
	$(VENV_DIR)/bin/molecule idempotence -s $(MOLECULE_SCENARIO)
