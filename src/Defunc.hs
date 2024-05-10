{-# LANGUAGE GADTs #-}

{-|
Module      : Defun
Description : A simple example of defunctionalization .
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

== Defunctionalization

Using

== References

- <https://injuly.in/blog/defunct/ Compiling higher order functions with GADTs>
- <https://www.cl.cam.ac.uk/~jdy22/papers/lightweight-higher-kinded-polymorphism.pdf Lightweight higher-kinded polymorphism>

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

-- | Fold a list.
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
-- == Defunctionalization
-- Defunctionalization of lambda expressions from the motivating example.

-- | Arrow data type with two function constructors representing the lambda
-- expressions from our motivating example.
data Arrow p r where
  FPlus :: Arrow (Int, Int) Int
  FPlusCons :: Int -> Arrow (Int, [Int]) [Int]

-- | Apply the Arrow to the input.
apply :: Arrow p r -> p -> r
apply FPlus (x, y)          = x + y
apply (FPlusCons n) (x, xs) = (n + x):xs

fold' :: Arrow (a, b) b -> b -> [a] -> b
fold' _ z []     = z
fold' f z (x:xs) = apply f (x, fold' f z xs)

-- | Sum using fold'.
sum' :: [Int] -> Int
sum' = fold' FPlus 0

-- | Add n to each element using fold'.
add' :: Int -> [Int] -> [Int]
add' n = fold' (FPlusCons n) []
