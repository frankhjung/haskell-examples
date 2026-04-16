# Examples

A collection of small Haskell modules that explore core language features,
type-level programming, algebraic abstractions, property testing, and basic IO.
The package is a library of examples under `src/` with a matching test suite
under `test/`. There is no executable target in the Cabal file.

## Project Layout

- `src/` contains the example modules exposed by the library in
  [Examples.cabal](Examples.cabal).
- `test/` contains one spec module per source module plus `TestsSpec.hs` for
  Hspec discovery.
- [Makefile](Makefile) provides formatting, linting, build, test, and Haddock
  targets.

## Build And Test

The default Make target formats, lint-checks, builds, and tests the project.

```bash
make
```

Useful commands:

```bash
cabal build
cabal test --test-show-details=direct
cabal repl
```

To build documentation:

```bash
make doc
```

## Tooling Notes

- The project uses [Cabal](https://cabal.readthedocs.io/en/stable/) for builds.
- [GHCup](https://www.haskell.org/ghcup/) is the intended toolchain manager.
- The pinned dependency set lives in
  [cabal.project.freeze](cabal.project.freeze).
- The CI pipeline is defined in [.gitlab-ci.yml](.gitlab-ci.yml).

## Module Guide

### [src/Cards.hs](src/Cards.hs)

Demonstrates pattern synonyms over a simple playing-card domain. The module uses
custom pattern constructors such as honor cards to make pattern matching clearer
while still preserving exhaustiveness checking.

### [src/Contravariant.hs](src/Contravariant.hs)

Explores contravariant functors through a wrapper that turns values into
strings. Its main purpose is to contrast `contramap` with ordinary covariant
mapping and show how function composition reverses direction.

### [src/Defunc.hs](src/Defunc.hs)

Shows defunctionalization with a GADT that represents operations as data. This
turns higher-order behavior into a first-order structure that can be interpreted
explicitly.

### [src/FuncType.hs](src/FuncType.hs)

Presents functions as first-class values wrapped in a custom type. The example
focuses on storing, composing, and applying functions through a small API.

### [src/Greeting.hs](src/Greeting.hs)

Collects several everyday Haskell patterns in one place: record syntax,
newtypes, derived instances, and type classes with default methods. It is a
general language-features example rather than a single algorithm.

### [src/Months.hs](src/Months.hs)

Defines a cyclic enumeration for months with wraparound predecessor and
successor operations. It also includes QuickCheck support so the cyclic laws can
be tested directly.

### [src/MyFreeMonad.hs](src/MyFreeMonad.hs)

Builds a small arithmetic DSL with the free monad. The point of the module is to
separate the description of computations from the interpreter that evaluates
them.

### [src/Nullable.hs](src/Nullable.hs)

Introduces a small type class for values that can be considered empty or null.
The examples show the same interface applied to different container-like types.

### [src/PolyList.hs](src/PolyList.hs)

Implements a heterogeneous list indexed by a type-level list. This module is a
type-system example focused on GADTs, `DataKinds`, and related extensions for
statically tracking element types.

### [src/PrefixSums.hs](src/PrefixSums.hs)

Implements prefix sums for efficient range queries after a preprocessing step.
The module is both an algorithm example and a property-testing example built on
monoids and QuickCheck.

### [src/RankNTypes.hs](src/RankNTypes.hs)

Demonstrates higher-rank polymorphism and existential-style packaging. It shows
how to work with values whose concrete types are hidden behind shared
capabilities such as `Show`.

### [src/Selector.hs](src/Selector.hs)

Explores higher-kinded types and generic selection behavior through a `Select`
type class. It also demonstrates deriving behavior for custom types via type
class structure.

### [src/ShowFile.hs](src/ShowFile.hs)

Provides the main IO-focused examples in the project. It covers reading and
writing files, inspecting file metadata, and working with time values from the
filesystem.

### [src/Singletons.hs](src/Singletons.hs)

Demonstrates singleton types and the connection between type-level and
value-level information. The module uses GADTs and promoted data to move more
checks to compile time.

### [src/Strings.hs](src/Strings.hs)

Contains a minimal string-oriented example based on a `newtype` wrapper and a
small text-processing helper. It serves as a compact demonstration of deriving
instances and simple list-based string manipulation.

## Tests

The test suite mirrors the source tree with one spec per module. Most examples
are pure library code; [src/ShowFile.hs](src/ShowFile.hs) is the main module
that exercises filesystem IO.

## References

- [Cabal](https://cabal.readthedocs.io/en/stable/)
- [Format Cabal Files](https://hackage.haskell.org/package/cabal-fmt)
- [GitLab Pages](https://haskell-examples-frankhjung1-04123b730cc28cc94ba032d712dcf83c17.gitlab.io/)
- [Haskell Cookbook](https://www.packtpub.com/product/haskell-cookbook/9781786461353)
- [hlint](https://github.com/ndmitchell/hlint)
- [Richard Eisenberg Videos](https://richarde.dev/videos.html)
- [Stylish Haskell](https://github.com/haskell/stylish-haskell)
- [TWEAG Videos](https://www.youtube.com/@tweag/playlists)
