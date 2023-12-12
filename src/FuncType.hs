{-|

Module      : FuncType
Description : Type with function value example.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

Code based off
<https://www.packtpub.com/product/haskell-cookbook/9781786461353 Haskell Cookbook by Yogesh Sajanikar, Chapter 3, Defining data with functions, page 83.>

Some use-cases for using functions as types:

== Generic programming and type classes

Functions as types play a crucial role in generic programming, where
algorithms are written to work with a variety of data types. Type classes,
which categorize types based on shared properties, often utilize functions
as types to define these properties and enable generic operations.

==  Metaprogramming and type-level computations

Functions as types enable metaprogramming, where programs manipulate other
programs or their representations. Type-level computations, where
calculations are performed at compile time using type information, can also
be achieved using functions as types.

-}

module FuncType
  ( -- * Types
    Func (..)
    -- * Functions
  , apply
  , compose
  ) where

-- | Type with function value.
newtype Func a b = Func (a -> b)

-- | Apply a function to a value.
apply :: Func a b -> a -> b
apply (Func f) = f

-- | Compose two functions.
compose :: Func a b -> Func b c -> Func a c
compose (Func f) (Func g) = Func (g . f)
