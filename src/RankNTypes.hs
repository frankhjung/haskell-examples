{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE RankNTypes                #-}

{-|

Module      : RankNTypes
Description : Abstracting function types with RankNTypes.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

Based on [Haskell Design Patterns by Ryan Lemmer, Chapter 5, Abstracting
function types: RankNTypes, page
88.](https://subscription.packtpub.com/book/programming/9781783988723).

The 'applyToFive' example is from [Thinking In
Types](https://thinkingwithtypes.com/) by Sandy Maguire.

The /rank/ of a function is the "depth" of its polymorphism. Most of
typical polymorphic functions in Haskell are of rank 1. e.g.:

@
const :: a -> b -> a
head :: [a] -> a
@

Using @-XRankNTypes@ extension makes polymorphism /first-class/. This
allows us to introduce polymorphism anywhere a type is allowed. The comprimise
is that /type inference/ becomes harder.

See also "PolyList" for other examples of RankNTypes.

-}

module RankNTypes
  (
    -- * Types
    ShowBox (..)
  , HasShow(..)
    -- * Functions
  , applyToFive
  , elimHasShow
  , processTuple
  ) where

-- | Process tuple with polymorphic function for 'Integral' types.
processTuple :: (Integral a1, Integral a2) => (forall a. Integral a => a -> Bool) -> (a1, a2) -> (Bool, Bool)
processTuple f (x, y) = (f x, f y)

-- | This is an existential type that allows you to construct heterogenous
-- lists of underlying different types (wrapped by the 'ShowBox' type).
--
-- For example:
--
-- @
-- heteroList :: [ShowBox]
-- heteroList = [SB (), SB 5, SB "hello"]
-- @
--
-- See also "PolyList" for an example of a polymorphic list.
data ShowBox = forall s. Show s => SB s

-- | Show instance for 'ShowBox'.
instance Show ShowBox where
  show (SB s) = show s

-- | Due to Haskell's implicit quantification of type variables, the
-- @forall a.@ part needs to be inside the parentheses. This requires the
-- @-XRankNTypes@ extension.
--
-- This function is of rank 2 as it receives a function of rank 1 as an argument
-- and runs it on the integer value 5.
applyToFive :: (forall a. a -> a) -> Int
applyToFive f = f 5

-- | 'HasShow' type example.
--
-- See [Thinking with Types](https://thinkingwithtypes.com/), Section 7.1
-- Existential Types and Eliminators
data HasShow where
  HasShow :: Show a => a -> HasShow

-- | Show instance for 'HasShow'.
--
-- Same as:
--
-- @
-- instance Show HasShow where
--   show (HasShow a) = show a
-- @
instance Show HasShow where
  show = elimHasShow show

-- | Eliminator for 'HasShow'.
--
-- Reads value of 'HasShow' type.
elimHasShow :: (forall a. Show a => a -> r) -> HasShow -> r
elimHasShow f (HasShow a) = f a
