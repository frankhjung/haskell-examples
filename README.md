# Utilities

A collection of code snippets and utilities.

## Build

Build using Cabal withL

```bash
cabal build
```

## hlint

Generate a report of hlint suggestions for a project.

```bash
hlint --git --report
```

Generate a default `.hlint.yaml` file.

```bash
hlint --default > .hlint.yaml
```

## Cabal Packages

### Install Missing Package

```bash
cabal install --overwrite-policy=always --lib <package-name>
```

### Package Versions

Tested locally using GHC 9.4.6 and Cabal 3.6.2.0 with these packages:

```bash
$ cabal freeze
active-repositories: hackage.haskell.org:merge
constraints: any.HUnit ==1.6.2.0,
             any.QuickCheck ==2.14.3,
             QuickCheck -old-random +templatehaskell,
             any.ansi-terminal ==1.0,
             ansi-terminal -example,
             any.ansi-terminal-types ==0.11.5,
             any.array ==0.5.4.0,
             any.base ==4.17.2.0,
             any.bytestring ==0.11.5.2,
             any.call-stack ==0.4.0,
             any.colour ==2.3.6,
             any.containers ==0.6.7,
             any.deepseq ==1.4.8.0,
             any.directory ==1.3.7.1,
             any.filepath ==1.4.2.2,
             any.ghc-bignum ==1.3,
             any.ghc-boot-th ==9.4.7,
             any.ghc-prim ==0.9.1,
             any.haskell-lexer ==1.1.1,
             any.hspec ==2.11.7,
             any.hspec-core ==2.11.7,
             any.hspec-discover ==2.11.7,
             any.hspec-expectations ==0.8.4,
             any.mtl ==2.2.2,
             any.pretty ==1.1.3.6,
             any.primitive ==0.9.0.0,
             any.process ==1.6.17.0,
             any.quickcheck-io ==0.2.0,
             any.random ==1.2.1.1,
             any.rts ==1.0.2,
             any.splitmix ==0.1.0.5,
             splitmix -optimised-mixer,
             any.stm ==2.5.1.0,
             any.template-haskell ==2.19.0.0,
             any.tf-random ==0.5,
             any.time ==1.12.2,
             any.transformers ==0.5.6.2,
             any.unix ==2.7.3
index-state: hackage.haskell.org 2023-11-01T08:02:02Z
``
