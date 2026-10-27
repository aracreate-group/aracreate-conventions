# SPDX-License-Identifier: LicenseRef-Proprietary
# Copyright (C) 2026, araCreate Group
# Author: Aravinth Panch <ara@aracreate.group>
# Description: Server baseline and app deploy tasks

SHELL      := /bin/bash
MOTD       := ../scripts/motd
CODE       := $(shell . ./shared.env && echo $$CODE)
LIB         = /opt/$(CODE)/lib
SUDO_RSYNC := --rsync-path="sudo rsync"
SSH_TO      = $(if $(LOGIN),$(LOGIN)@)$(SRV)
APP_DIR     = /opt/$(APP)
COMPOSE     = cd $(APP_DIR) && sudo docker compose

################################################################################
# Help
################################################################################
.DEFAULT_GOAL := help

help:
	@cat $(MOTD)
	@echo "========================================================================"
	@echo "make banner SRV=s        --> Write s/banner from BANNER in s/server.env"
	@echo "make baseline SRV=s [LOGIN=u] --> Copy base/ and s/ to the server, apply both; LOGIN=u logs in as u on a first run"
	@echo "make secret SRV=s NAME=n KEY=k --> Prompt for one value, set k in s:/opt/<code>/secrets/n.env"
	@echo "make notify-test SRV=s   --> Send a test alert from s"
	@echo "make sync SRV=s APP=a    --> Copy app a's config to /opt/a"
	@echo "make setup SRV=s APP=a   --> Create or top up /opt/a/.env, generating secrets"
	@echo "make deploy SRV=s APP=a  --> Copy config, pull images, start or update"
	@echo "make set-secret SRV=s APP=a KEY=k --> Prompt for one .env value, set it on s"
	@echo "make ps SRV=s APP=a      --> Show the stack's containers"
	@echo "make logs SRV=s APP=a    --> Follow the stack's logs"
	@echo "========================================================================"
	@echo ""

################################################################################
# Targets
################################################################################
.PHONY: help need-srv need-app banner baseline secret notify-test \
        sync setup deploy set-secret ps logs

need-srv:
	@test -n "$(SRV)" -a -f "$(SRV)/server.env" || \
	  { echo "usage: SRV=<server folder with a server.env>"; exit 1; }

need-app: need-srv
	@test -n "$(APP)" -a -d "$(SRV)/$(APP)" || \
	  { echo "usage: APP=<app folder in $(SRV)>"; exit 1; }

banner: need-srv
	@. $(SRV)/server.env && figlet -f "ANSI Shadow" "$$BANNER" > $(SRV)/banner
	@cat $(SRV)/banner

# BOOTSTRAP_FROM=<ip> lets SSH in from that address while the tunnel is not up;
# LOGIN=<user> logs in as the image's own user before the admins exist
baseline: need-srv
	@printf "\n==> Copying to $(SRV):$(LIB)\n\n"
	@ssh $(SSH_TO) 'sudo install -d -m 755 $(LIB)'
	@rsync -rlpt --delete $(SUDO_RSYNC) base shared.env $(SRV) $(SSH_TO):$(LIB)/
	@printf "\n==> Applying\n"
	@ssh $(SSH_TO) 'sudo EXTRA_SSH_FROM="$(BOOTSTRAP_FROM)" $(LIB)/base/baseline $(LIB)/$(SRV)'

# Run by an admin in a terminal: the value is typed, never shown or logged, and set
# in a secret file the baseline made with its owner and mode
secret: need-srv
	@test -n "$(NAME)" -a -n "$(KEY)" || { echo "usage: NAME=<secret> KEY=<key>"; exit 1; }
	@read -rsp "$(KEY) in $(NAME) on $(SRV): " val; echo; \
	 printf '%s\n' "$$val" | ssh $(SRV) 'sudo $(CODE)-set-secret $(NAME) $(KEY)'

notify-test: need-srv
	@ssh $(SRV) 'sudo $(CODE)-notify info test "Test alert from $(SRV)"'

sync: need-app
	@printf "\n==> Copying $(APP) to $(SRV):$(APP_DIR)\n\n"
	@ssh $(SRV) 'sudo install -d -m 755 $(APP_DIR)'
	@rsync -rlpt $(SUDO_RSYNC) --exclude .env $(SRV)/$(APP)/ $(SRV):$(APP_DIR)/

setup: sync
	@printf "\n==> Setting up $(APP_DIR)/.env\n\n"
	@ssh $(SRV) 'sudo install -d -m 755 $(LIB)/base'
	@rsync -rlpt $(SUDO_RSYNC) base/setup-env $(SRV):$(LIB)/base/
	@ssh $(SRV) 'sudo $(LIB)/base/setup-env $(APP_DIR)'

deploy: sync
	@printf "\n==> Deploying $(APP)\n\n"
	@ssh $(SRV) '$(COMPOSE) pull --ignore-buildable && $(COMPOSE) up -d --build'

# Run by an admin in a terminal: prompts for one key's value, never shown, and sets
# it in the app's .env on the server
set-secret: need-app
	@test -n "$(KEY)" || { echo "usage: KEY=<name in .env>"; exit 1; }
	@read -rsp "$(KEY): " val; echo; \
	 printf '%s\n' "$$val" | ssh $(SRV) 'sudo perl -i -pe "BEGIN { chomp(\$$v = <STDIN>) } s/^$(KEY)=.*/$(KEY)=\$$v/" $(APP_DIR)/.env'

ps: need-app
	@ssh $(SRV) '$(COMPOSE) ps'

logs: need-app
	@ssh -t $(SRV) '$(COMPOSE) logs -f --tail=100'
