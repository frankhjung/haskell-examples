module PatSynsSpec
  ( spec
  ) where

import           PatSyns    (Honor (..), checkEven, numCardsToPlay)
import           Test.Hspec (Spec, describe, it, shouldBe)

spec :: Spec
spec =
  describe "PatSyns" $ do
    it "checkEven" $ do
      checkEven 2 `shouldBe` True
      checkEven 3 `shouldBe` False
    it "numCardsToPlay" $ do
      numCardsToPlay HJack `shouldBe` 1
      numCardsToPlay HQueen `shouldBe` 2
      numCardsToPlay HKing `shouldBe` 3
      numCardsToPlay HAce `shouldBe` 4
