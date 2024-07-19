.ONESHELL:
SHELL = /bin/bash

.PHONY: help
help:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m %-30s\033[0m %s\n", $$1, $$2}'

.PHONY: serve
serve: ## documentation of first_command
	rm -rf docs/
	hugo serve 