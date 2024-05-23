{-# LANGUAGE RankNTypes #-}

module RankNTypesSpec(spec) where

import           RankNTypes            (HasShow (..), ShowBox (..), applyToFive,
                                        elimHasShow, processTuple)
import           Test.Hspec            (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec = do
  describe "Rank2Types" $ do
    prop "processTuple even" $ \(x :: Word, y :: Int)
      -> processTuple even (x, y) == (even x, even y)
    prop "processTuple odd" $ \(x :: Integer, y :: Word)
      -> processTuple odd (x, y) == (odd x, odd y)
    it "applyToFive id" $ applyToFive id `shouldBe` 5
  describe "Existential Quantification" $
    prop "ShowBox" $ \(i :: Int, xs :: String)
      -> map show [SB (), SB i, SB xs] == [show (), show i, show xs]
  describe "Existential Types and Eliminators" $
    prop "HasShow" $ \(xs :: String)
      -> elimHasShow show (HasShow xs) == show xs
