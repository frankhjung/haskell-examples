{-|

Module      : FuncType
Description : Types with functions as values.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

Code based off
<https://www.packtpub.com/product/haskell-cookbook/9781786461353 Haskell Cookbook by Yogesh Sajanikar, Chapter 3, Defining data with functions, page 83.>

Some use-cases for using functions as types:

== Generic programming and type classes

Functions as types are essential in generic programming, where algorithms are
designed to operate seamlessly across various data types. Type classes, which
organize types according to shared characteristics, frequently leverage
functions as types to articulate these characteristics and facilitate generic
operations.

==  Meta-programming and type-level computations

Meta-programming and type-level computations involve the use of functions as
types. This concept allows programs to manipulate other programs or their
representations. Additionally, functions as types facilitate type-level
computations, where calculations are carried out during compile time using type
information.

-}

module FuncType
  ( -- * Types
    Func (..)
    -- * Functions
  , apply
  , compose
  ) where

-- | Type with a function value.
newtype Func a b = Func (a -> b)

-- | Apply function to a value.
apply :: Func a b -> a -> b
apply (Func f) = f

-- | Compose two functions.
compose :: Func a b -> Func b c -> Func a c
compose (Func f) (Func g) = Func (g . f)
