{-# LANGUAGE DerivingStrategies #-}
{-|

Module      : Strings
Description : Example string functions.
Copyright   : © Frank Jung, 2021-2023
License     : GPL-3.0-only

-}

module Strings
  ( -- * Types
    CharList(..)
    -- * Functions
  , removeNonUpperCase
  ) where

-- | Example of creating and using new types.
--
-- >>> CharList "this will be shown!"
-- CharList {getCharList = "this will be shown!"}
--
-- >>> CharList "benny" == CharList "benny"
-- True
--
-- >>> CharList "benny" == CharList "andy"
-- False
newtype CharList = CharList { getCharList :: String }
  deriving stock (Eq, Show)

-- | Remove non upper case characters.
--
-- >>> removeNonUpperCase("ABcdeF")
-- "ABF"
removeNonUpperCase :: String -> String
removeNonUpperCase s = [c | c <- s, c `elem` ['A' .. 'Z']]
