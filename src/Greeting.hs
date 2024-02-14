{-# LANGUAGE DefaultSignatures  #-}
{-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE StandaloneDeriving #-}

{-|

Module      : Greeting
Description : Effective Haskell module example.
Copyright   : © Frank Jung, 2023-2024
License     : GPL-3.0-only

-}

module Greeting (
  -- * Types
  Name (..)
  , Salutation (..)
  , GreetingMessage (..)
  , Redacted (..)
  , Common (..)
  , Secret (..)
  , UserName (..)
  , AdminUser (..)
  -- * Functions
  , defaultMessage
  , formatMessage
) where

import           Data.List (intercalate)
import           Fmt       (fmt, (+|), (|+))


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
  fmt $ "" +| s |+ ", " +| to |+ "!" +| fromStr |+ ""
  where
    fromStr
      | null from = ""
      | otherwise = " from " <> intercalate ", " (map getName from)

-- | Redacted type class.
class Redacted a where
  redacted :: a -> String
  default redacted :: Show a => a -> String
  redacted = show

-- | Common type.
newtype Common = Common String
-- | Override Show instance to echo result with out type signature.
-- A better way is to use GeneralizedNewtypeDeriving extension to derive Show instance.
instance Show Common where
  show (Common s) = s

-- | Common type instance of Redacted.
-- This will echo the string as is.
instance Redacted Common

-- | Secret type.
newtype Secret = Secret String
-- | Secret type instance of Redacted will not show string.
instance Redacted Secret where
  redacted _ = "(redacted)"

-- | Simpler way to implement Redacted instance for Secret.
-- Needs the `DeriveAnyClass` extension.
-- Overrides Show instance to give a customised value.
newtype UserName = UserName String deriving (Eq, Redacted)
instance Show UserName where
  show (UserName user) = "UserName: " <> user

-- | AdminUer type. Will override Redacted instance to give a customised value.
newtype AdminUser = AdminUser UserName deriving stock Show
instance Redacted AdminUser where
  redacted (AdminUser (UserName user)) = "AdminUser: " <> user
