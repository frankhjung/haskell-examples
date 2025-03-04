{-# LANGUAGE DerivingStrategies #-}

module MyFreeMonadSpec (spec) where

import           MyFreeMonad     (evalArith, example, exampleDo)
import           Test.Hspec      (Spec, describe, it, shouldBe)
import           Test.QuickCheck (Arbitrary (..), choose, property)

-- This is a pure Haskell function that performs the same set of arithmetic
-- steps directly on an `Int`.
--
-- The prop tests ensure that, for any `Int` input `x`, the result of evaluating
-- the `ArithM` computation is the same as the result of applying myfun to `x`.
myfun :: Int -> Int
myfun x = ((x+10)*2-10) `div` 2

-- Restrict the input range for QuickCheck to avoid potential
-- division by zero or overflow issues.
newtype SmallInt = SmallInt Int
  deriving stock (Show, Eq)

instance Arbitrary SmallInt where
    arbitrary = SmallInt <$> choose (-1000, 1000)

spec :: Spec
spec = describe "Arithmetic Examples" $ do
    it "example x == myfun x" $ property $ \(SmallInt x) ->
        evalArith (example x) `shouldBe` myfun x
    it "exampleDo x == myfun x" $ property $ \(SmallInt x) ->
        evalArith (exampleDo x) `shouldBe` myfun x
    it "example x == exampleDo x" $ property $ \(SmallInt x) ->
        evalArith (example x) `shouldBe` evalArith (exampleDo x)
