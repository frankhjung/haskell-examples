{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE RankNTypes                #-}

{-|

Module      : RankNTypes
Description : Abstracting function types with RankNTypes.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

Based on [Haskell Design Patterns by Ryan Lemmer, Chapter 5, Abstracting
function types: RankNTypes, page
88.](https://subscription.packtpub.com/book/programming/9781783988723)

-}

module RankNTypes (processTuple, ShowBox (..)) where

-- | Process tuple with polymorphic function for 'Integral' types.
processTuple :: (Integral a1, Integral a2) => (forall a. Integral a => a -> Bool) -> (a1, a2) -> (Bool, Bool)
processTuple f (x, y) = (f x, f y)

-- | This is an existential type that allows you to construct heterogenous lists
-- of underlying different types (wrapped by the 'ShowBox' type).
--
-- For example:
--
-- @
-- heteroList :: [ShowBox]
-- heteroList = [SB (), SB 5, SB "hello"]
-- @
data ShowBox = forall s. Show s => SB s

-- | Show instance for 'ShowBox'.
instance Show ShowBox where
  show (SB s) = show s
