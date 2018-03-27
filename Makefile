MAKEFLAGS += --silent
SHELL := /bin/bash
GEMSPEC_NAME = resume_app.gemspec
DOCKER_IMAGE_NAME = carlosnunez/resume_app
VERSION_FILE = version
APP_SPECIFIC_VERSION_FILE = lib/resume_app/version.rb
DOCKER_IMAGE_TAG = $(shell cat version)

ifndef TRAVIS
include .env
export $(shell sed 's/=.*//' .env)
TERRAFORM_STATE_ENVIRONMENT = $(shell echo local_$$USER)
else
ifndef TERRAFORM_STATE_ENVIRONMENT
TERRAFORM_STATE_ENVIRONMENT = integration
endif
endif

include include/make/*.mk
include include/make/*/*.mk

local_build:
	$(MAKE) init && \
	$(MAKE) static_analysis && \
	$(MAKE) unit_tests && \
	$(MAKE) _set_travis_env_vars
ci_build:
	$(MAKE) init && \
	$(MAKE) static_analysis && \
	$(MAKE) unit_tests && \
	$(MAKE) bump_the_version_number && \
	$(MAKE) publish_application && \
	$(MAKE) integration_setup && \
	$(MAKE) integration_tests && { \
		$(MAKE) integration_teardown; \
		echo "Tests passed."; \
	} || { \
		$(MAKE) integration_teardown; \
		echo "Tests failed."; \
	}

# Shared build steps.
.PHONY: validate_environment init

validate_environment: _ensure_environment_is_configured

init: BUNDLE_OPTIONS=--quiet 
init: validate_environment \
	_bundle_install \
	_terraform_get \
	get_latest_commit_hash

.PHONY: static_analysis unit_tests integration_tests

static_analysis: BUNDLE_OPTIONS=rake static_analysis:style
static_analysis: validate_environment \
	_bundle_exec

unit_tests: USE_REAL_VALUES_FOR_TFVARS=false
unit_tests: BUNDLE_OPTIONS=rake unit:test
unit_tests: validate_environment \
	_generate_terraform_tfvars \
	_terraform_init_with_test_backend \
	_generate_test_terraform_plan \
	_generate_test_terraform_plan_json \
	_bundle_exec \
	_delete_terraform_tfvars

.PHONY: publish_application
publish_application: validate_environment \
	_build_gem \
	_build_docker_image \
	_push_docker_image_to_docker_hub

.PHONY: deploy_app
deploy_app:
	echo "$(INFO) Working on it\!"; \
	exit 0

.PHONY: integration_tests integration_setup integration_teardown
integration_setup: ADDITIONAL_TERRAFORM_ARGS=-auto-approve -input=false
integration_setup: validate_environment \
	_terraform_init_with_s3_backend \
	_generate_terraform_tfvars \
	_terraform_apply
ifndef TRAVIS
integration_teardown:
	echo "Since we've built this on a local box, integration will be kept up."; \
	exit 0
else
integration_teardown: _terraform_destroy
endif
integration_tests: BUNDLE_OPTIONS=rake integration:test
integration_tests: _bundle_exec

.PHONY: bump_the_version_number
bump_the_version_number:
	current_version_number=$$(cat $(APP_SPECIFIC_VERSION_FILE) | \
												 grep VERSION | \
												 sed "s#.*VERSION = '\([0-9\.]\+\)'.*#\1#"); \
	new_version_number=$$(date +%Y.%m.%d); \
	if [ "$$current_version_number" == "$$new_version_number" ]; \
	then \
		exit 0; \
	fi; \
	sed -i "s/VERSION = '$$current_version_number'/VERSION = '$$new_version_number'/" \
		$(APP_SPECIFIC_VERSION_FILE)
