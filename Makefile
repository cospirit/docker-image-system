.SILENT:

include Makefile.mk

HELP_INDENT = 26

IMAGE   := ardeveloppement/system
VERSION := $(shell cat VERSION)

## Build image
build:
	docker build \
		--pull \
		--tag $(IMAGE) \
		.

## Tag image (VERSION)
tag:
	docker tag \
		$(IMAGE) \
		$(IMAGE):$(VERSION)

## Push image tag into repository (VERSION)
push:
	$(call confirm, Confirm pushing of image $(COLOR_COMMENT)$(IMAGE):$(VERSION))
	docker push \
		$(IMAGE):$(VERSION)

## Run temporary image's container (APP,ENVIRONMENT,PHP_VERSION)
run:
	$(call message, ~(‾▿‾)~ Browse at $(COLOR_COMMENT)http://127.0.0.1:9000)
	docker run \
		--rm \
		$(if $(APP),--env APP=$(APP)) \
		$(if $(ENVIRONMENT),--env ENVIRONMENT=$(ENVIRONMENT)) \
		$(if $(PHP_VERSION),--env PHP_VERSION=$(PHP_VERSION)) \
		$(if $(APP),--mount type=bind$(,)source=$(PWD)/tests/app/fixtures/$(APP)$(,)target=/srv/app) \
		--name $(subst /,_,$(IMAGE)) \
		--publish 9000:80 \
		--publish 9001:10000 \
		$(IMAGE)

## Run temporary image's container / Angular (ENVIRONMENT)
run/angular: APP = angular
run/angular: run

## Run temporary image's container / Html (ENVIRONMENT)
run/html: APP = html
run/html: run

## Run temporary image's container / Php (ENVIRONMENT,PHP_VERSION)
run/php: APP = php
run/php: run

## Run temporary image's container / Silex (ENVIRONMENT,PHP_VERSION)
run/silex: APP = silex
run/silex: run

## Run temporary image's container / Symfony 2 (ENVIRONMENT,PHP_VERSION)
run/symfony_2: APP = symfony_2
run/symfony_2: run

## Run temporary image's container / Symfony 4 (ENVIRONMENT,PHP_VERSION)
run/symfony_4: APP = symfony_4
run/symfony_4: run

## Run temporary image's container / Vue.js (ENVIRONMENT)
run/vuejs: APP = vuejs
run/vuejs: run

## Shell into temporary image's container
sh:
	docker exec \
		--tty --interactive \
		$(subst /,_,$(IMAGE))\
		bash

## Test image
test:
	RETURN=0 ; \
	for TEST in tests/*/ ; do \
		$(call log,$${TEST%/}) ; \
		$${TEST}run || ((RETURN++)) ; \
		printf "\n" ; \
	done; \
	exit $${RETURN}
