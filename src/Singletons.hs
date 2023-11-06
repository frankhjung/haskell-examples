{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GADTs              #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# OPTIONS_GHC -Wall #-}

{-|

Module      : Singletons
Description : Examples of the singleton data type.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

This is from a talk by Richard Eisenberg about Generalized Abstract Data Types.

Singletons are a useful work-around for dependent types in Haskell.
Singletons can be used for:

(1) /reflection
2. /reification
3. promoting function values to become functions on types
4. /defunctionalization/ (turning functions into data)

A key benefit is the ability to move runtime errors into compile time errors.

/Type erasure/ In Haskell, types only exist at compile-time, for help with
type-checking. They are completely erased at runtime.

== Resources

From <https://www.youtube.com/@tweag Tweag YouTube channel> specifically
<https://richarde.dev/2021/ Richard Eisenberg>'s
<https://richarde.dev/videos.html series> on Haskell.

See also:

(1) <https://hackage.haskell.org/package/singletons-base singletons: Basic singleton types and definitions>
2. <https://hackage.haskell.org/package/singletons singletons-base: A promoted and singled version of the base library>
3. <https://richarde.dev/papers/2012/singletons/paper.pdf Dependently Typed
   Programming with Singletons (PDF)>
4. <https://blog.jle.im/entry/introduction-to-singletons-1.html Introduction to Singletons by Justin Le>

== Returning different types does not work

However, returning different types does not work. For example, one way to define
a function that returns different types depending upon
the 'SingT' parameter.

But this does not work because the 't' type is not known at compile time. It
should return a type 't' not a type 'Maybe a' constructor which has no
arguments.

@
one :: SingT t -> t
one SInt       = 1
one SBool      = True
one (SMaybe _) = Just ()
@

-}
module Singletons (
  --  * Types
    SingT(..)
  , Wrap(..)
  -- * Functions
  , zero
  , eqSingT) where

-- | A very simple newtype wrapper.
newtype Wrap a = Wrap a deriving stock (Show)

-- | 'SingT' is a example of a Singleton type.
-- This is an [indexed type](https://wiki.haskell.org/GHC/Type_families).
--
-- This gets compiled as:
--
-- @
-- data SingT t
--   = (t ~ Int) => SInt
--   | (t ~ Bool) => SBool
--   | forall a. (t ~ Maybe a) => SMaybe (SingT a)
--   | forall a. (t ~ [a]) => SList (SingT a)
--   | (t ~ ()) => SUnit
--   | forall a b. (t ~ (a -> b)) => SArrow (SingT a) (SingT b)
--   | forall a. (t ~ Wrap a) => SWrap (SingT a)
-- @
data SingT t where
  SArrow :: SingT a -> SingT b -> SingT (a -> b)
  SBool :: SingT Bool
  SInt :: SingT Int
  SList :: SingT a -> SingT [a]
  SMaybe :: SingT a -> SingT (Maybe a)
  SUnit :: SingT ()
  SWrap :: SingT a -> SingT (Wrap a)

deriving instance Show (SingT t)

-- | Zero: This function can return difference types, depending upon the
-- 'SingT' parameter.
--
-- === Examples
--
-- >>> zero SInt
-- 0
-- >>> zero SWrap SBool
-- False
-- >>> zero (SMaybe SInt)
-- Nothing
zero :: SingT t -> t
zero (SArrow _ res) = const (zero res)
zero SBool          = False
zero SInt           = 0
zero (SList _)      = []
zero (SMaybe _)     = Nothing
zero SUnit          = ()
zero (SWrap a)      = Wrap (zero a)

-- One: this doesn't work because the 't' type is not known at compile time.
-- one :: SingT t -> t
-- one (SArrow _ res) = const (one res)
-- one SBool          = True
-- one SInt           = 1
-- one (SList _)      = [one (SList SInt)]
-- one (SMaybe _)     = Just (one SUnit)
-- one SUnit          = ()
-- one (SWrap a)      = Wrap (one a)

-- | Define equality for each Singleton type.
eqSingT :: SingT t -> SingT t -> Bool
eqSingT (SArrow a b) (SArrow c d) = a `eqSingT` c && b `eqSingT` d
eqSingT SBool SBool               = True
eqSingT SInt SInt                 = True
eqSingT (SList a) (SList b)       = a `eqSingT` b
eqSingT (SMaybe a) (SMaybe b)     = a `eqSingT` b
eqSingT SUnit SUnit               = True
eqSingT (SWrap a) (SWrap b)       = a `eqSingT` b
