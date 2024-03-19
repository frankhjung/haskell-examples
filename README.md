# Utilities

A collection of Haskell code snippets used to explore the language and key
concepts.

The project contains a [Makefile](Makefile) to validate, build and test the
project. The default make target will format, lint, build and test the project.

```bash
make
```

## Lint using hlint

Generate a report of [hlint](https://github.com/ndmitchell/hlint) suggestions
for a project:

```bash
hlint --git --report
```

Generate a default `.hlint.yaml` file:

```bash
hlint --default > .hlint.yaml
```

## Build using Cabal

The project uses [Cabal](https://cabal.readthedocs.io/en/stable/) to manage and
build the project. See [Example.cabal](Example.cabal) for the specific packages
used. The following commands are useful to maintain the project:

### Install Missing Packages

```bash
cabal install --overwrite-policy=always --lib <package-name>
```

### Package Versions

Tested locally using GHC 9.4.8 and Cabal 3.10.2.1 with these packages
[cabal.project.freeze](cabal.project.freeze)

To update this file, run:

```bash
cabal freeze
```

## GHCup

The project uses [GHCup](https://www.haskell.org/ghcup/) to manage and build the
project.

## References

* [Cabal](https://cabal.readthedocs.io/en/stable/)
* [GitLab pages](https://haskell-examples-frankhjung1-04123b730cc28cc94ba032d712dcf83c17.gitlab.io/)
* [Haskell Cookbook](https://www.packtpub.com/product/haskell-cookbook/9781786461353)
* [hlint](https://github.com/ndmitchell/hlint)
* [Richard Eisenberg's Videos](https://richarde.dev/videos.html)
* [TWEAG Video Playlists](https://www.youtube.com/@tweag/playlists)
