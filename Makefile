DOCKER_COMPOSE_BINARY := docker-compose
DOCKER_COMPOSE_FILES := docker-compose-files
DOCKER_COMPOSE_PIP_COMPILER_FILE := $(DOCKER_COMPOSE_FILES)/pip-compiler.yaml
DOCKER_COMPOSE_UNIT_TEST_FILE := $(DOCKER_COMPOSE_FILES)/unit-tests.yaml
DOCKER_COMPOSE_INTEGRATION_TEST_FILE := $(DOCKER_COMPOSE_FILES)/integration-tests.yaml
DOCKER_COMPOSE_BUILD_APP_FILE := $(DOCKER_COMPOSE_FILES)/build-app.yaml

export VERSION := $(shell git rev-parse --short HEAD)

validate-docker-compose-files: $(DOCKER_COMPOSE_FILES)/*
	for file in $^ ; do \
		$(DOCKER_COMPOSE_BINARY) --file="$${file}" config > /dev/null || exit $?; \
	done

build-unit-tests:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_UNIT_TEST_FILE) build unit-tests

unit-tests: build-unit-tests
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_UNIT_TEST_FILE) run --rm unit-tests

build-integration-tests:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) build integration-tests

integration-tests: build-integration-tests
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_INTEGRATION_TEST_FILE) run --rm integration-tests

update-unit-tests-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm pip-compiler

update-integration-tests-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm pip-compiler

update-app-requirements:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_PIP_COMPILER_FILE) run --rm  pip-compiler

build-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_BUILD_APP_FILE) build --force-rm --no-cache

run-app:
	@$(DOCKER_COMPOSE_BINARY) --file=$(DOCKER_COMPOSE_BUILD_APP_FILE) run --rm app
