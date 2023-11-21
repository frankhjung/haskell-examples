{-# LANGUAGE ScopedTypeVariables #-}
module MonthsSpec
  ( spec
  ) where

import           Months                (Month (..), cpred, csucc, makeMonth)
import           Test.Hspec            (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec =
  describe "Months" $ do
    prop "to (from) enum is enum" $ \(x :: Month) ->
      toEnum (fromEnum x) `shouldBe` x
    it "from enum" $ do
      fromEnum January `shouldBe` 0
      fromEnum December `shouldBe` 11
    it "to enum" $ do
      toEnum 0 `shouldBe` January
      toEnum 11 `shouldBe` December
    prop "succ (pred) is enum" $ \(x :: Month) ->
      csucc (cpred x) `shouldBe` x
    it "csucc" $ do
      csucc January `shouldBe` February
      csucc December `shouldBe` January
    it "cpred" $ do
      cpred January `shouldBe` December
      cpred December `shouldBe` November
    it "makeMonth" $ do
      makeMonth "jANuary" `shouldBe` Just January
      makeMonth "february" `shouldBe` Just February
      makeMonth "MARCH" `shouldBe` Just March
      makeMonth "Invalid" `shouldBe` (Nothing :: Maybe Month)
