module SelectorSpec
  ( spec
  ) where

import           Selector              (MyMaybe (..), Select (..),
                                        Selector (..))
import           Test.Hspec            (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec = do
    describe "Select from Maybe" $ do
        it "select" $
            select (Just 1) Nothing `shouldBe` (Just 1 :: Maybe Int)
        it "empty" $
            empty `shouldBe` (Nothing :: Maybe Int)
        prop "select Nothing (Just x) is (Just x)" $
            \(x :: Maybe Int) -> select Nothing x `shouldBe` x
        prop "select (Just x) y is (Just x)" $
            \(x :: Int, y :: Maybe Int) -> select (Just x) y `shouldBe` Just x
    describe "Select from List" $ do
        it "select" $
            select [1, 2, 3] [4, 5, 6] `shouldBe` ([1, 2, 3, 4, 5, 6] :: [Int])
        it "empty" $
            empty `shouldBe` ([] :: [Int])
        prop "select [] [xs] is [xs]" $
            \(xs :: [Int]) -> select [] xs `shouldBe` xs
        prop "select [xs] [] is [xs]" $
            \(xs :: [Int]) -> select xs [] `shouldBe` xs
    describe "Selector for a Maybe" $ do
      it "Selector Monoid Nothing"
        $ Selector (Nothing :: Maybe Int)
            `shouldBe` (Selector empty :: Selector Maybe Int)
      prop "Selector Semigroup Just values" $ \(x :: Int) (y :: Int) ->
        Selector (Just x) <> Selector (Just y) `shouldBe` Selector (Just x)
      prop "Selector Semigroup Nothing" $ \(y :: Maybe Int) ->
        Selector Nothing <> Selector y `shouldBe` Selector y
    describe "MyMaybe" $ do
        prop "MyMaybe (Just x) <> MyMaybe (Just y) is MyMaybe (Just x)" $
            \(x :: Int, y:: Maybe Int) -> MyMaybe (Just x) <> MyMaybe y `shouldBe` MyMaybe (Just x)
        prop "MyMaybe Nothing <> MyMaybe (Just y)" $
            \(y :: Maybe Int) -> MyMaybe Nothing <> MyMaybe y `shouldBe` MyMaybe y
