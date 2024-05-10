{-# LANGUAGE ConstraintKinds           #-}
{-# LANGUAGE DataKinds                 #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE FlexibleInstances         #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE ScopedTypeVariables       #-}
{-# LANGUAGE TypeFamilies              #-}
{-# LANGUAGE TypeOperators             #-}
{-# LANGUAGE UndecidableInstances      #-}

{-|
Module      : PolyList
Description : Polymorhic list.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

From Thinking with Types, Sandy Maguire, 2021, section 5.3 Heterogeneous Types.

== Source

See <https://github.com/isovector/thinking-with-types Thinking with Types> for
code and solutions to exercises.

== Unable to Derive Functor for Hetereogeneous Lists

Unfortunately, for your PolyList type, it's not possible to create a Functor
instance because PolyList is indexed by a type-level list of types, and Functor
requires a type constructor of kind @* -> *@, i.e., a type constructor that
takes exactly one type argument.

The PolyList type is a heterogeneous list that can contain values of different
types, and the type of each value is encoded in the type of the list itself.
This is fundamentally different from the concept of a Functor, which operates
on homogeneous containers that contain values of a single type.

-}

module PolyList
  (
    -- * Types
    PolyList (..)
  , HEntry (..)
    -- * Functions
  , pLength
  , pHead
  ) where

import           Data.Kind (Constraint, Type)

-- | A constraint that applies to all types in a list.
type family All (c :: Type -> Constraint) (ts :: [Type]) :: Constraint where
  All _ '[] = ()
  All c (t : ts) = (c t, All c ts)

-- | A list that contain polymorphic types.
data PolyList (ts :: [Type]) where
  PNil :: PolyList '[]
  (:#) :: t -> PolyList ts -> PolyList (t ': ts)
infixr 5 :#

instance All Eq ts => Eq (PolyList ts) where
  PNil == PNil           = True
  (a :# as) == (b :# bs) = a == b && as == bs

instance (All Eq ts, All Ord ts) => Ord (PolyList ts) where
  PNil `compare` PNil         = EQ
  compare (a :# as) (b :# bs) = compare a b  <> compare as bs

instance (All Show ts) => Show (PolyList ts) where
  show PNil      = "PNil"
  show (a :# as) = show a <> " :# " <> show as

-- | Get the length of a polymorphic list.
pLength :: PolyList ts -> Int
pLength PNil      = 0
pLength (_ :# ts) = 1 + pLength ts

-- | Get the head of a polymorphic list.
pHead :: PolyList (t ': ts) -> t
pHead (t :# _) = t

-- | An alternate implementation of a heterogenous item.
-- The 'HEntry' type is an existential wrapper around a value of any type that
-- has a 'Show' instance. This allows us to store values of different types in a
-- list, but we can't derive 'Eq' or 'Ord' for 'HEntry' because the types are
-- potentially different.
data HEntry = forall a. Show a => HEntry a

instance Show HEntry where
  show (HEntry a) = show a
