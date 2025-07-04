#!/usr/bin/env make

.DEFAULT_GOAL	:= default

TARGET	:= Examples
SRCS	:= $(wildcard */*.hs)

.PHONY: default
default: format check build test

.PHONY: all
all:	format check build test doc

.PHONY: format
format:	$(SRCS)
	@echo format ...
	@cabal-fmt --inplace $(TARGET).cabal
	@stylish-haskell --inplace $(SRCS)

.PHONY: check
check:	tags lint

.PHONY: tags
tags:	$(SRCS)
	@echo tags ...
	@hasktags --ctags --extendedctag $(SRCS)

.PHONY: lint
lint:	$(SRCS)
	@echo lint ...
	@hlint --cross --color --show $(SRCS)
	@cabal check

.PHONY: build
build:  $(SRCS)
	@cabal build

.PHONY: test
test:
	@cabal test --test-show-details=direct

.PHONY: doc
doc:
	@echo doc ...
	@cabal haddock --haddock-quickjump --haddock-hyperlink-source

.PHONY: setup
setup:
	-touch -d "2023-11-22T04:27:27UTC" LICENSE
ifeq (,$(wildcard ${CABAL_CONFIG}))
	-cabal user-config init
	-cabal update --only-dependencies
else
	@echo Using user-config from ${CABAL_CONFIG} ...
endif

.PHONY: clean
clean:
	@cabal clean

.PHONY: distclean
distclean: clean
	@$(RM) tags
