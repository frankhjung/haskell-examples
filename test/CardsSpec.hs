module CardsSpec
  ( spec
  ) where

import           Cards      (Card (..), Honor (..), checkEven, numCardsToPlay)
import           Test.Hspec (Spec, describe, it, shouldBe)

spec :: Spec
spec =
  describe "Cards" $ do
    it "checkEven" $ do
      checkEven 2 `shouldBe` True
      checkEven 3 `shouldBe` False
    it "numCardsToPlay" $ do
      numCardsToPlay HJack `shouldBe` 1
      numCardsToPlay HQueen `shouldBe` 2
      numCardsToPlay HKing `shouldBe` 3
      numCardsToPlay HAce `shouldBe` 4
    it "honour card ordering" $ do
      HJack < HQueen `shouldBe` True
      HQueen < HKing `shouldBe` True
      HKing < HAce `shouldBe` True
    it "card ordering" $ do
      C10 < CJack `shouldBe` True
      CJack < CQueen `shouldBe` True
      CQueen < CKing `shouldBe` True
      CKing < CAce `shouldBe` True
