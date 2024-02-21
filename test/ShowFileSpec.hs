{-# LANGUAGE ScopedTypeVariables #-}

module ShowFileSpec
  ( spec
  ) where

import           ShowFile                  (showFile)

import           Test.Hspec                (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck     (prop)
import           Test.QuickCheck.Modifiers (NonEmptyList (NonEmpty))


-- | Shows two different ways to test a function that uses IO.
spec :: Spec
spec = do
  describe "showFile" $ do
    it "showFile /etc/passwd" $ do
      result <- showFile "/etc/passwd"
      result `shouldBe` "no passwd"
    prop "showFile random_file" $ do
      \(NonEmpty (x :: FilePath)) -> showFile x >>= (`shouldBe` x)
