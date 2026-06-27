################################################################################
#
# description = "CLIENT-PRODUCT-PROJECT"
# author      = "Aravinth Panch <ara@aracreate.group>"
# copyright   = "Copyright (C) 2026, araCreate Group"
# license     = "LicenseRef-Proprietary"
# version     = "0.0.1"
#
################################################################################
SHELL   := /bin/bash
SRC_DIR := ./src

################################################################################
# Help
################################################################################
.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "========================================================================"
	@echo " CLIENT-PRODUCT-PROJECT"
	@echo "========================================================================"
	@echo "make install        --> Install dependencies"
	@echo "make setup          --> Set up environment"
	@echo "make dev            --> Run locally"
	@echo "make build          --> Build / compile"
	@echo "make test           --> Run tests"
	@echo "make release        --> Cut a semantic release"
	@echo "make clean          --> Remove build artefacts"
	@echo "========================================================================"
	@echo ""

################################################################################
# Targets
################################################################################
install:
	@echo "\n==> Installing dependencies\n"

setup:
	@echo "\n==> Setting up environment\n"

dev:
	@echo "\n==> Running locally\n"

build:
	@echo "\n==> Building\n"

test:
	@echo "\n==> Running tests\n"

release:
	@echo "\n==> Cutting release\n"

clean:
	@echo "\n==> Cleaning build artefacts\n"
