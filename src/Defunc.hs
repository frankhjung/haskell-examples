{-# LANGUAGE GADTs #-}

{-|
Module      : Defunc
Description : A simple example of defunctionalisation .
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

== Defunctionalization

A small example to show how to defunctionalise lambda functions.

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
