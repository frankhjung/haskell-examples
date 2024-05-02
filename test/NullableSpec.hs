module NullableSpec (
    spec
  ) where

import           Data.Maybe            (isNothing)
import           Nullable              (Nullable (..))

import           Prelude               hiding (null)
import qualified Prelude               (null)
import           Test.Hspec            (Spec, describe, it, shouldBe,
                                        shouldSatisfy)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec = do
  describe "Nullable Maybe" $ do
    it "satisfies is null" $
      (Nothing :: Maybe Int) `shouldSatisfy` isNull
    it "null" $
      Nullable.null `shouldBe` (Nothing :: Maybe Int)
    prop "maybe int" $
      \(x :: Maybe Int) -> isNull x `shouldBe` isNothing x
  describe "Nullable List" $ do
    it "is null" $
      isNull ([] :: [Int]) `shouldBe` True
    it "null" $
      Nullable.null `shouldBe` ([] :: [Int])
    prop "list of int" $
      \(x :: [Int]) -> isNull x `shouldBe` Prelude.null x
