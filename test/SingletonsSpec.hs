{-# LANGUAGE ScopedTypeVariables #-}

module SingletonsSpec
  ( spec
  ) where

import           Singletons            (SingT (SBool, SInt, SList, SMaybe, SUnit, SWrapper),
                                        convertViaInt, eqSingT, zero)
import           Test.Hspec            (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec = do
  describe "zero" $ do
    it "zero SBool" $
      zero SBool `shouldBe` False
    it "zero SInt" $
      zero SInt `shouldBe` (0 :: Int)
    it "zero SList[Bool]" $
      zero (SList SBool) `shouldBe` ([] :: [Bool])
    it "zero SMaybe Int" $
      zero (SMaybe SInt) `shouldBe` (Nothing :: Maybe Int)
    it "zero SUnit" $
      zero SUnit `shouldBe` ()
  describe "eqSingT" $ do
    it "eqSingT (SMaybe a) (SMaybe b)" $
      eqSingT (SMaybe SInt) (SMaybe SInt) `shouldBe` True
    it "eqSingT (SWrapper a) (SWrapper b)"
      $ eqSingT (SWrapper SInt) (SWrapper SInt) `shouldBe` True
  prop "convertViaInt" $
    \(x :: Int) -> convertViaInt x `shouldBe` x
