COMPOSE := docker compose
ENV_FILE := .env

.DEFAULT_GOAL := help

.PHONY: help up down restart logs ps config

help: ## Lista os comandos disponíveis
	@awk 'BEGIN {FS = ": .*## "; printf "\nComandos disponíveis:\n\n"} /^[a-zA-Z0-9_-]+: .*## / {printf "  %-12s %s\n", $$1, $$2} END {printf "\n"}' $(MAKEFILE_LIST)

up: ## Sobe o stack completo do Typebot
	@test -f "$(ENV_FILE)" || (printf "\nCrie %s a partir de .env.example antes de subir o stack.\n\n" "$(ENV_FILE)" && exit 1)
	$(COMPOSE) --env-file $(ENV_FILE) up -d

down: ## Derruba o stack do Typebot
	$(COMPOSE) --env-file $(ENV_FILE) down

restart: down up ## Reinicia o stack do Typebot

logs: ## Exibe logs do stack
	$(COMPOSE) --env-file $(ENV_FILE) logs -f

ps: ## Lista os containers do stack
	$(COMPOSE) --env-file $(ENV_FILE) ps

config: ## Valida a configuração final do docker compose
	@test -f "$(ENV_FILE)" || (printf "\nCrie %s a partir de .env.example antes de validar o stack.\n\n" "$(ENV_FILE)" && exit 1)
	$(COMPOSE) --env-file $(ENV_FILE) config
