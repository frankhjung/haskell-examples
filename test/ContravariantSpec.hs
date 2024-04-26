{-# LANGUAGE ScopedTypeVariables #-}

module ContravariantSpec
  ( spec
  ) where

import           Contravariant         (MakeString (..), plus3ShowInt, showInt)
import           Test.Hspec            (Spec, describe, shouldBe)
import           Test.Hspec.QuickCheck (prop)


spec :: Spec
spec =
  describe "MakeString" $ do
    prop "showInt" $
        \(x :: Int) -> makeString showInt x `shouldBe` show x
    prop "plust3ShowInt" $
        \(x :: Int) -> makeString plus3ShowInt x `shouldBe` show (x+3)
