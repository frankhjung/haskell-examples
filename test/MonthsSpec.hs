module MonthsSpec
  ( spec
  ) where

import           Months     (Month (..), cpred, csucc, makeMonth)
import           Test.Hspec (Spec, describe, it, shouldBe)

spec :: Spec
spec =
  describe "Months" $ do
    it "from enums" $ do
      fromEnum January `shouldBe` 0
      fromEnum December `shouldBe` 11
    it "to enums" $ do
      toEnum 0 `shouldBe` January
      toEnum 11 `shouldBe` December
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
