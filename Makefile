DOCKER_REGISTRY ?= dkrhub.alliedinsure.com.mv

UID ?= 1000

THIS_FILE := $(lastword $(MAKEFILE_LIST))


# Build required images.
.PHONY: build-dev
build-dev:
	docker build --build-arg USER_IDENT=$(UID) -t py38int .
	
	@echo "Development image of name 'py38int' built successfully. Now run 'make start' to start development."

.PHONY: start
start:
	docker run -it --rm -v $(HOME)/.composer:/tmp --user $(UID) -v $$(pwd)/dc_mould:/home/user/app -v $$(pwd)/dist:/home/user/dist py38int bash

.PHONY: build-prod
build-prod:
	docker build -f production.dockerfile -t dc_mould .
	
	@echo "Production image of name 'dc_mould' built successfully."