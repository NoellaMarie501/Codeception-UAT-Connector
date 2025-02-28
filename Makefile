ROOT_DIR       := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL          := $(shell which bash)
PROJECT_NAME    = digitech-uat
ARGS            = $(filter-out $@,$(MAKECMDGOALS))

include variables.env
.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
default: help-default;   # default target
Makefile: ;              # skip prerequisite discovery


build:
	docker-compose --project-name $(PROJECT_NAME) build

digitech-pull: auth2
	docker pull ${DIGITECH}

migrate:
	bash digitech-migrate.sh 127.0.0.1 2533

up:
	docker-compose --project-name $(PROJECT_NAME) up -d

stop:
	docker-compose --project-name $(PROJECT_NAME) stop

reset: stop clean build up

clean: stop
	docker-compose --project-name $(PROJECT_NAME) down --remove-orphans

auth2:
	aws ecr get-login-password | docker login --username AWS --password-stdin 190853051067.dkr.ecr.eu-central-1.amazonaws.com
app-logs:
	docker logs -f $$(docker-compose --project-name $(PROJECT_NAME) ps -q connector-app)
test-logs:
	docker logs -f $$(docker-compose --project-name $(PROJECT_NAME) ps -q tests-app)
app-root:
	docker exec -it -u root $$(docker-compose --project-name $(PROJECT_NAME) ps -q connector-app) /bin/bash 
test-root:
	docker exec -it -u root $$(docker-compose --project-name $(PROJECT_NAME) ps -q tests-app) /bin/bash
execute-test:
	docker exec -it -u root $$(docker-compose --project-name $(PROJECT_NAME) ps -q tests-app) /bin/bash  
%:
	@:
