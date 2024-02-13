{-# LANGUAGE DerivingVia    #-}
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
    Select (..)
  , Selector(..)
  , MyMaybe(..)
  ) where

import           Data.Kind (Type)

-- | A class for types that can be used to select between two values.
class Select (f :: Type -> Type) where
  empty :: f a
  select :: f a -> f a -> f a

-- | Instances of 'Select' for 'Maybe'.
instance Select Maybe where
  empty = Nothing
  select Nothing a = a
  select a _       = a

-- | Instances of 'Select' for lists '[]'.
instance Select [] where
  empty = []
  select = (<>)

-- | 'Selector' type.
newtype Selector (f :: Type -> Type) (a :: Type) = Selector (f a)
  deriving (Show, Eq)

-- | Semigroup instance for 'Selector'.
instance (Select f) => Semigroup (Selector f a) where
  (Selector a) <> (Selector b) = Selector (select a b)

-- | Monoid instance for 'Selector'.
instance (Select f) => Monoid (Selector f a) where
  mempty = Selector empty

-- | 'MyMaybe' and 'Selector Maybe a' are representationally equal to 'Maybe a'.
newtype MyMaybe a = MyMaybe (Maybe a)
  deriving (Show, Eq)
  deriving (Semigroup, Monoid) via (Selector Maybe a)
