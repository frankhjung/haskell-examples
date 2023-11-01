module Strings (
    -- * Types
    CharList(..)
    -- * Functions
    , removeNonUpperCase) where

-- new types
-- >>> CharList "this will be shown!"
-- CharList {getCharList = "this will be shown!"}
-- >>> CharList "benny" == CharList "benny"
-- True
-- >>> CharList "benny" == CharList "andy"
-- False
newtype CharList = CharList
  { getCharList :: String
  } deriving (Eq, Show)

-- remove non upper case characters
-- >>> removeNonUpperCase("ABcdeF")
-- "ABF"
removeNonUpperCase :: String -> String
removeNonUpperCase s = [c | c <- s, c `elem` ['A' .. 'Z']]
