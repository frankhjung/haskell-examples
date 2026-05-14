{-# LANGUAGE GADTs #-}

{-|
Module      : Defunc
Description : A simple example of defunctionalisation.
Copyright   : © Frank Jung, 2024, 2026
License     : GPL-3.0-only

== Defunctionalization

Defunctionalisation is a technique that replaces higher-order function
values with a first-order representation. Instead of passing lambdas or
closures directly, you encode the possible operations as constructors of an
algebraic data type and interpret them with an application function.

The code below shows this transformation for a small list fold example.
The higher-order @fold@ accepts a combining function, while @fold'@ accepts
an @Arrow@ value whose behaviour is defined by @apply@.

=== Why Use It?

* __Explicit representation:__ The set of supported operations becomes a
closed data type that can be inspected and manipulated.

* __Captured values become data:__ The @n@ in @FPlusCons n@ is stored as a
constructor field rather than hidden inside a closure.

* __Type safety with GADTs:__ The @Arrow@ GADT records the input and output
types for each encoded operation.

* __A first-order core:__ Higher-order control flow is replaced by a small
interpreter, which can simplify analysis or later compilation passes.

=== Key Principle

The main tradeoff is that first-class functions are replaced with a closed
set of function tags plus an interpreter. In this example, @(+)@ and
@\x xs -> x + n : xs@ become the constructors @FPlus@ and @FPlusCons@,
and @apply@ performs the work that the original function values did.

== References

- [Compiling higher order functions with GADTs](https://injuly.in/blog/defunct/)
- [Lightweight higher-kinded polymorphism](https://www.cl.cam.ac.uk/~jdy22/papers/lightweight-higher-kinded-polymorphism.pdf)

-}
module Defunc
  (
  -- * Types
  Arrow (..)
  -- * Functions
  , fold
  , sum
  , add
  , apply
  , fold'
  , sum'
  , add'
  ) where

import           Prelude hiding (sum)

-- |
-- == Motivation
-- The motivating example is the following functions.

-- | Fold a list using recursion.
fold :: (a -> b -> b) -> b -> [a] -> b
fold _ z []     = z
fold f z (x:xs) = f x (fold f z xs)

-- | Sum using fold.
sum :: [Int] -> Int
sum = fold (+) 0

-- | Add one to each element using fold.
add :: Int -> [Int] -> [Int]
add n = fold (\x xs -> x + n : xs) []

-- |
-- == Defunctionalisation
-- Defunctionalisation of lambda expressions from the motivating example.

-- | Arrow data type with two function constructors representing the lambda
-- expressions from our motivating example.
data Arrow p r where
  FPlus :: Arrow (Int, Int) Int
  FPlusCons :: Int -> Arrow (Int, [Int]) [Int]

-- | Apply the Arrow to the input.
apply :: Arrow p r -> p -> r
apply FPlus (x, y)          = x + y
apply (FPlusCons n) (x, xs) = (n + x):xs

-- | Fold a list using the Arrow.
fold' :: Arrow (a, b) b -> b -> [a] -> b
fold' _ z []     = z
fold' f z (x:xs) = apply f (x, fold' f z xs)

-- | Sum using fold'.
sum' :: [Int] -> Int
sum' = fold' FPlus 0

-- | Add n to each element using fold'.
add' :: Int -> [Int] -> [Int]
add' n = fold' (FPlusCons n) []
