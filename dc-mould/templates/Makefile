DOCKER_REGISTRY ?= dkrhub.alliedinsure.com.mv

UID ?= 1000
GID ?= 1000

THIS_FILE := $(lastword $(MAKEFILE_LIST))

# Shell access to app container.

.PHONY: {{data.app.name}}-bash
{{data.app.name}}-bash:
	docker-compose exec --user $(UID):$(GID) {{data.app.name}} bash

# Container preparation routines.

.PHONY: {{data.app.name}}-prepare
{{data.app.name}}-prepare: {{data.app.name}}-touch
	docker-compose exec --user $(UID):$(GID) {{data.app.name}} /usr/src/aidock/build/prepare.sh


.PHONY: prepare-all
prepare-all: {{data.app.name}}-prepare
	@echo "Post setup done for all application components."






# Bring up/down services.

.PHONY: up
up: {{data.app.name}}-touch
	docker-compose up -d {{data.app.name}}

.PHONY: down
down:
	docker-compose down






# Create required directories and files in host machine.

.PHONY: {{data.app.name}}-touch
{{data.app.name}}-touch:
	cp -n ./.env.example ./.env
	
	cp -n ./{{data.app.name}}/.env.example ./{{data.app.name}}/.env
	touch ./{{data.app.name}}/storage/logs/laravel.log
	
	touch ./{{data.app.name}}-dc/.env
	mkdir -p ./{{data.app.name}}-dc/.npm
	mkdir -p ./{{data.app.name}}-dc/.npm-appuser
	mkdir -p ./{{data.app.name}}-dc/log
	touch ./{{data.app.name}}-dc/log/php-error.log