module DefuncSpec
  ( spec
  ) where

import           Defunc                (add, add', sum, sum')
import           Prelude               hiding (sum)
import qualified Prelude               (sum)
import           Test.Hspec            (Spec, describe, shouldBe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec = do
  describe "motivation" $ do
    prop "sum " $ \(xs :: [Int]) -> sum xs `shouldBe` Prelude.sum xs
    prop "add" $ \(n :: Int, xs :: [Int]) -> add n xs `shouldBe` map (+ n) xs
  describe "defunctionalization" $ do
      prop "sum'" $ \(xs :: [Int]) -> sum' xs `shouldBe` sum xs
      prop "add'" $ \(n :: Int, xs :: [Int]) -> add' n xs `shouldBe` add n xs
