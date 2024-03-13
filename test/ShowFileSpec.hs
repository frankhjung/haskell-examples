{-# LANGUAGE ScopedTypeVariables #-}

module ShowFileSpec
  ( spec
  ) where

import           ShowFile                  (FileInfo (..), getFileInfo,
                                            showContent, showTime)

import           Test.Hspec                (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck     (prop)
import           Test.QuickCheck.Modifiers (NonEmptyList (NonEmpty))

-- | Shows two different ways to test a function that uses IO.
spec :: Spec
spec = do
  describe "showContent" $ do
    it "showContent /etc/passwd" $ do
      result <- showContent "/etc/passwd"
      result `shouldBe` "no passwd"
    prop "showContent random_file" $ do
      \(NonEmpty (x :: FilePath)) -> showContent x >>= (`shouldBe` x)
    it "getFileInfo LICENSE" $ do
      result <- getFileInfo "LICENSE" -- requires touch of file in pipeline
      _size result `shouldBe` 35149
      showTime (_mtime result) `shouldBe` "2023-11-22T04:27:27UTC"
      _read result `shouldBe` True
      _write result `shouldBe` True
      _exec result `shouldBe` False
