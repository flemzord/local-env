.PHONY: help

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	DOCKER_CMD = docker-compose
endif
ifeq ($(UNAME_S),Darwin)
	DOCKER_CMD = docker compose
endif

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: start-all
.DEFAULT_GOAL := help
COMPOSE_FILE_PATH := -f docker-compose.yml -f $(shell find ./repos -type f -name "docker-compose.yml" -exec echo {} + | sed -e "s/ / -f /g")

install: mkcert certificate clone start-all
	@echo "All is OK"
mkcert:
	@mkcert -install
certificate:
	@if [ ! -d "certs/local-cert.pem" ]; then mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "*.app.localhost"; fi
clone:
	@if [ ! -d "repos/example" ]; then git clone git@github.com:flemzord/local-env-laravel.git repos/example; fi
start-all: ## Start the container
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) up -d --remove-orphans
build-all: ## Build the container
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) build
logs-all: ## Print All Logs
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) logs -f --tail 10
logs: ## Print log for specific service
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) logs -f --tail 10 $(SERVICE)
start: ## start container for specific service
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) up $(SERVICE)
stop: ## stop container for specific service
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) stop $(SERVICE)
build: ## build container for specific service
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) build $(SERVICE)
stop-all: ## Stop all the container
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) stop
ps: ## Look status for all container
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) ps
rm: stop-all ## Remove all the container
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) rm -f
	@docker system prune --volumes --force
	$(info Make: Remove environment containers.)
exec: ## Exec in container
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) exec ${SERVICE} ${CMD}
ssh: ## SSH in container
	@$(DOCKER_CMD) $(COMPOSE_FILE_PATH) exec ${SERVICE} bash