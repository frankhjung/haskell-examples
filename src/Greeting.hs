{-# LANGUAGE StandaloneDeriving #-}

{-|

Module      : Greeting
Description : Effective Haskell module example.
Copyright   : © Frank Jung, 2023
License     : GPL-3.0-only

== TODO

- refactor to use `fmt` package

-}

module Greeting (
  -- * Types
  Name (..)
  , Salutation (..)
  , GreetingMessage (..)
  -- * Functions
  , defaultMessage
  , formatMessage
) where

import           Data.List (intercalate)

-- | Name type.
newtype Name = Name {getName :: String}
deriving instance Eq Name
deriving instance Show Name

-- | Salutation type.
newtype Salutation = Salutation {getSalutation :: String}
deriving instance Eq Salutation
deriving instance Show Salutation

-- | Greeting message type. It consists of a salutation, a name to greet,
-- and a list of names from whom the greeting is from.
data GreetingMessage = GreetingMessage {
    greetingSalutation :: Salutation
  , greetingTo         :: Name
  , greetingFrom       :: [Name]}
deriving instance Eq GreetingMessage
deriving instance Show GreetingMessage

{-| Default greeting message.

@
'defaultMessage' {
    'greetingSalutation' :: 'Salutation' \"Hello\"
  , 'greetingTo'         :: Name \"World\"
  , 'greetingFrom'       :: []}
}
@

-}
defaultMessage :: GreetingMessage
defaultMessage = GreetingMessage {
    greetingSalutation = Salutation "Hello"
  , greetingTo = Name "World"
  , greetingFrom = []}

{- | Format greeting message.

>>> formatMessage defaultMessage
"Hello, World!"

>>> formatMessage (defaultMessage {greetingTo = Name "Robyn", greetingFrom = [Name "Frank"]})
"Hello, Robyn! from Frank"

-}
formatMessage :: GreetingMessage -> String
formatMessage (GreetingMessage (Salutation s) (Name to) from) =
    s <> ", " <> to <> "!" <> fromStr
    where
      fromStr
        | null from = ""
        | otherwise = " from " <> intercalate ", " (map getName from)
