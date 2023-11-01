#!/usr/bin/env make

.DEFAULT_GOAL := default

CABAL	:= Examples.cabal
SRCS	:= $(wildcard src/*.hs test/*.hs)

.PHONY:	default
default: format check build exec

.PHONY: all
all:	format check build exec

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
	@hlint --git --color $(SRCS)

.PHONY: build
build:	$(SRCS)
	@cabal build

.PHONY: test
test:
	@cabal test

.PHONY: exec
exec:	# Example:  make ARGS=30 exec (default 15 fizz-buzz iterations)
	@cabal run $(TARGET)

.PHONY: setup
setup:
	@cabal update --only-dependencies

.PHONY: clean
clean:
	@cabal clean

.PHONY: cleanall
cleanall: clean
	@$(RM) -rf *.tix
	@$(RM) -f cabal.project.freeze
