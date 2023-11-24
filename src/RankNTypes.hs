{-# LANGUAGE RankNTypes #-}

{-|
Module      : RankNTypes
Description : Abstracting function types with RankNTypes.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

Based on
<https://subscription.packtpub.com/book/programming/9781783988723 Haskell Design Patterns by Ryan Lemmer, Chapter 5, Abstracting function types: RankNTypes, page 88.>

-}

module RankNTypes (processTuple) where

-- | Process tuple with polymorphic function for 'Integral' types.
processTuple :: (Integral a1, Integral a2) => (forall a. Integral a => a -> Bool) -> (a1, a2) -> (Bool, Bool)
processTuple f (x, y) = (f x, f y)
