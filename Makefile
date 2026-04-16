#!/usr/bin/env make

.DEFAULT_GOAL	:= default

TARGET	:= Examples
SRCS	:= $(wildcard */*.hs)

.PHONY: help
help: ## Show this help message
	@echo Available targets:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

.PHONY: default
default: format check build test ## Run the standard local workflow

.PHONY: all
all:	format check build test doc ## Run all checks, tests, and docs

.PHONY: format
format:	$(SRCS) ## Format cabal and Haskell source files
	@echo format ...
	@cabal-fmt --inplace $(TARGET).cabal
	@stylish-haskell --inplace $(SRCS)

.PHONY: check
check:	tags lint ## Regenerate tags and run linters

.PHONY: tags
tags:	$(SRCS) ## Generate ctags for the source tree
	@echo tags ...
	@hasktags --ctags --extendedctag $(SRCS)

.PHONY: lint
lint:	$(SRCS) ## Run HLint and cabal package checks
	@echo lint ...
	@hlint --cross --color --show $(SRCS)
	@cabal check

.PHONY: build
build:  $(SRCS) ## Build the project
	@cabal build

.PHONY: test
test: ## Run the test suite
	@cabal test --test-show-details=direct

.PHONY: doc
doc: ## Build Haddock documentation
	@echo doc ...
	@cabal haddock --haddock-quickjump --haddock-hyperlink-source

.PHONY: setup
setup: ## Initialize cabal user configuration and dependencies
	-touch -d "2023-11-22T04:27:27UTC" LICENSE
ifeq (,$(wildcard ${CABAL_CONFIG}))
	-cabal user-config init
	-cabal update --only-dependencies
else
	@echo Using user-config from ${CABAL_CONFIG} ...
endif

.PHONY: clean
clean: ## Remove build artifacts
	@cabal clean

.PHONY: distclean
distclean: clean ## Remove build artifacts and generated tags
	@$(RM) tags
