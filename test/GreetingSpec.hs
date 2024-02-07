{-# LANGUAGE DisambiguateRecordFields #-}
{-# LANGUAGE ScopedTypeVariables      #-}

module GreetingSpec
  ( spec
  ) where

import           Data.List                 (intercalate)
import           Greeting                  (Common (..), GreetingMessage (..),
                                            Name (..), Redacted (..),
                                            Salutation (..), Secret (..),
                                            defaultMessage, formatMessage,
                                            redacted)
import           Test.Hspec                (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck     (prop)
import           Test.QuickCheck.Modifiers (NonEmptyList (NonEmpty))

spec :: Spec
spec =
  describe "Greeting" $ do
    it "formatMessage with default" $
      formatMessage defaultMessage `shouldBe` "Hello, World!"
    it "formatMessage with custom default greeting" $
      formatMessage (defaultMessage {greetingTo = Name "Robyn", greetingFrom = [Name "Frank"]})
        `shouldBe` "Hello, Robyn! from Frank"
    it "formatMessage with greeting message" $
      formatMessage (GreetingMessage (Salutation "Hi") (Name "Robyn") [Name "Frank", Name "Dianne"])
        `shouldBe` "Hi, Robyn! from Frank, Dianne"
    prop "formatMessage with random from list" $
      \(NonEmpty (xs::[String])) -> formatMessage (defaultMessage {greetingFrom = map Name xs})
        `shouldBe` "Hello, World! from " <> intercalate ", " xs
    prop "redacted Common" $
      \(s :: String) -> redacted (Common s) `shouldBe` s
    prop "redacted Secret" $
      \(s :: String) -> redacted (Secret s) `shouldBe` "(redacted)"
