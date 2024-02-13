{-# LANGUAGE KindSignatures #-}

{-|

Module      : Selector
Description : Using Higher Kinded Types with your own Types and Classes.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

From "Effective Haskell" by Rebecca Skinner (B9.0 14 March 2023).

-}

module Selector
  ( -- * Types
    MyMaybe(..)
  , Selector(..)
  ) where

import           Data.Kind (Type)

-- | A newtype wrapper for 'Maybe'.
newtype MyMaybe a = MyMaybe (Maybe a) deriving (Show, Eq)

instance Semigroup (MyMaybe a) where
  (MyMaybe a) <> (MyMaybe b) = MyMaybe (select a b)

instance Monoid (MyMaybe a) where
  mempty = MyMaybe empty

-- | A class for types that can be used to select between two values.
class Selector (f :: Type -> Type) where
  empty :: f a
  select :: f a -> f a -> f a

-- | Instances of 'Selector' for 'Maybe'.
instance Selector Maybe where
  empty = Nothing
  select Nothing a = a
  select a _       = a

-- | Instances of 'Selector' for lists '[]'.
instance Selector [] where
  empty = []
  select  = (<>)
