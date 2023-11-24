{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}

module RankNTypesSpec(spec) where

import           RankNTypes            (processTuple)
import           Test.Hspec            (Spec, describe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec =
  describe "Rank2Types" $ do
    prop "processTuple even" $ \(x :: Word, y :: Int)
      -> processTuple even (x, y) == (even x, even y)
    prop "processTuple odd" $ \(x :: Integer, y :: Word)
      -> processTuple odd (x, y) == (odd x, odd y)
