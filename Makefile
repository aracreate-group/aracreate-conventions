# SPDX-License-Identifier: LicenseRef-Proprietary
# Copyright (C) 2026, araCreate Group
# Author: Aravinth Panch <ara@aracreate.group>
# Description: CLIENT-PRODUCT-PROJECT: Unified build and environment tasks

SHELL   := /bin/bash
SRC_DIR := ./src
MOTD    := ./scripts/motd

################################################################################
# Help
################################################################################
.DEFAULT_GOAL := help

help:
	@cat $(MOTD)
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
.PHONY: help install setup dev build test release clean

install:
	@printf "\n==> Installing dependencies\n\n"

setup:
	@printf "\n==> Setting up environment\n\n"

dev:
	@printf "\n==> Running locally\n\n"

build:
	@printf "\n==> Building\n\n"

test:
	@printf "\n==> Running tests\n\n"

release:
	@printf "\n==> Cutting release\n\n"

clean:
	@printf "\n==> Cleaning build artefacts\n\n"
