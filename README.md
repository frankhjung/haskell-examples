# Utilities

A collection of code snippets and utilities.

## Build using Cabal

Build using Cabal with:

```bash
cabal build
```

## Lint using hlint

Generate a report of hlint suggestions for a project:

```bash
hlint --git --report
```

Generate a default `.hlint.yaml` file:

```bash
hlint --default > .hlint.yaml
```

## Manage Packages with Cabal

This project is using [Cabal](https://cabal.readthedocs.io/en/stable/) to manage
packages.  The following commands are useful:

### Install Missing Packages

```bash
cabal install --overwrite-policy=always --lib <package-name>
```

### Package Versions

Tested locally using GHC 9.4.6 and Cabal 3.6.2.0 with these packages:

```bash
cabal freeze
```

See [cabal.project.freeze](cabal.project.freeze)

## References

* [Cabal](https://cabal.readthedocs.io/en/stable/)
* [GitLab pages](https://haskell-examples-frankhjung1-04123b730cc28cc94ba032d712dcf83c17.gitlab.io/)
* [Haskell Cookbook](https://www.packtpub.com/product/haskell-cookbook/9781786461353)
* [hlint](https://github.com/ndmitchell/hlint)
* [Richard Eisenberg's Videos](https://richarde.dev/videos.html)
* [TWEAG Video Playlists](https://www.youtube.com/@tweag/playlists)
