module SingletonsSpec
  ( spec
  ) where

import           Singletons (SingT (SBool, SInt, SList, SMaybe, SUnit, SWrap),
                             eqSingT, zero)
import           Test.Hspec (Spec, describe, it, shouldBe)

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
    it "eqSingT (SWrap a) (SWrap b)"
      $ eqSingT (SWrap SInt) (SWrap SInt) `shouldBe` True
