.PHONY: up-dev up down migrate build build-multi logs shell rails clean help

COMPOSE_FILES = -f docker-compose.yml -f docker-compose.dev.yml

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

up-dev: ## Start development environment
	docker compose $(COMPOSE_FILES) up -d

up: ## Start production environment
	docker compose -f docker-compose.yml up -d

down: ## Stop all services
	docker compose $(COMPOSE_FILES) down

migrate: ## Run database migrations
	docker compose $(COMPOSE_FILES) run --rm web bin/rails db:migrate

build: ## Build the backend image for current architecture
	docker build -t minechat_backend -f ../backend/Dockerfile ../backend

build-multi: ## Build multi-arch image (requires docker buildx)
	docker buildx build --platform linux/amd64,linux/arm64 -t minechat_backend -f ../backend/Dockerfile ../backend

build-multi-push: ## Build and push multi-arch image (requires docker buildx)
	docker buildx build --platform linux/amd64,linux/arm64 -t minechat_backend -f ../backend/Dockerfile ../backend --push

logs: ## Follow logs from all services
	docker compose $(COMPOSE_FILES) logs -f

logs-web: ## Follow web service logs
	docker compose $(COMPOSE_FILES) logs -f web

logs-sidekiq: ## Follow sidekiq service logs
	docker compose $(COMPOSE_FILES) logs -f sidekiq

shell: ## Open a shell in the web container
	docker compose $(COMPOSE_FILES) exec web bash

rails: ## Run rails commands in the web container (e.g. make rails -- db:console)
	docker compose $(COMPOSE_FILES) exec web bin/rails $(filter-out $@,$(MAKECMDGOALS))

console: ## Open rails console
	docker compose $(COMPOSE_FILES) exec web bin/rails console

db-console: ## Open database console
	docker compose $(COMPOSE_FILES) exec web bin/rails dbconsole

restart: ## Restart all services
	docker compose $(COMPOSE_FILES) restart

clean: ## Stop and remove all containers, volumes, and images
	docker compose $(COMPOSE_FILES) down -v
	docker rmi minechat_backend 2>/dev/null || true

%:
	@:
