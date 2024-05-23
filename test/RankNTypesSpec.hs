{-# LANGUAGE RankNTypes #-}

module RankNTypesSpec(spec) where

import           RankNTypes            (ShowBox (..), applyToFive, processTuple)
import           Test.Hspec            (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec = do
  describe "Rank2Types" $ do
    prop "processTuple even" $ \(x :: Word, y :: Int)
      -> processTuple even (x, y) == (even x, even y)
    prop "processTuple odd" $ \(x :: Integer, y :: Word)
      -> processTuple odd (x, y) == (odd x, odd y)
  describe "ExistentialQuantification" $
    prop "ShowBox" $ \(i :: Int, xs :: String)
      -> map show [SB (), SB i, SB xs] == [show (), show i, show xs]
  describe "applyToFive" $
    it "applyToFive id" $
      applyToFive id `shouldBe` 5
