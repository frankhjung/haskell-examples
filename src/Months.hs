{-# LANGUAGE DeriveAnyClass #-}
{-# OPTIONS_GHC -Wall #-}

{-|
Module      : Months
Description : Type class example.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

From <https://www.packtpub.com/product/haskell-cookbook/9781786461353 Haskell Cookbook by Yogesh Sajanikar, Chapter 3, Working with Type Classes, page 95.>

-}

module Months
  ( -- * Types
    Month (..)
    -- * Type classes
  , CyclicEnum (..)
    -- * Functions
  , makeMonth
  ) where

import           Data.Char       (toLower, toTitle)
import           Test.QuickCheck (Arbitrary (..), elements)
import           Text.Read       (readMaybe)

-- | Cyclic bounded enumeration of compass directions.
class (Eq a, Enum a, Bounded a) => CyclicEnum a where
  -- | Predecessor of a Cyclic enumeration.
  cpred :: a -> a
  cpred x
    | x == minBound = maxBound
    | otherwise = pred x
  -- | Successor of a Cyclic enumeration.
  csucc :: a -> a
  csucc x
    | x == maxBound = minBound
    | otherwise = succ x

-- | Months of the year.
data Month
  = January
  | February
  | March
  | April
  | May
  | June
  | July
  | August
  | September
  | October
  | November
  | December
  deriving (Eq, Ord, Show, Read, Enum, Bounded, CyclicEnum)

-- | Arbitrary instance for 'Month'.
instance Arbitrary Month where
  arbitrary = elements [minBound..maxBound]

-- | Make a 'Month' from a string.
makeMonth :: String -> Maybe Month
makeMonth = readMaybe . capitalise

-- | Title case a string.
capitalise :: String -> String
capitalise = zipWith id (toTitle : repeat toLower)
