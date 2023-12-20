#!/usr/bin/env make

.DEFAULT_GOAL := default

CABAL	:= Examples.cabal
SRCS	:= $(wildcard */*.hs)

.PHONY:	default
default: format check build test

.PHONY: all
all:	format check build test doc

.PHONY: format
format:
	@cabal-fmt --inplace $(CABAL)
	@stylish-haskell --inplace $(SRCS)

.PHONY: check
check:	tags lint

.PHONY: tags
tags:
	@hasktags --ctags --extendedctag $(SRCS)

.PHONY: lint
lint:
	@hlint --cross --color $(SRCS)

.PHONY: build
build:	$(SRCS)
	@cabal build

.PHONY: test
test:
	@cabal test --test-show-details=direct

.PHONY: doc
doc:
	@cabal haddock --haddock-hyperlink-source

.PHONY: setup
setup:
	@cabal update --only-dependencies

.PHONY: clean
clean:
	@cabal clean

.PHONY: cleanall
cleanall: clean
	@$(RM) -f tags
