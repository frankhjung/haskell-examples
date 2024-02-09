{-# LANGUAGE ScopedTypeVariables #-}

module SelectorSpec
  ( spec
  ) where

import           Selector              (Selector (..))
import           Test.Hspec            (Spec, describe, it, shouldBe)
import           Test.Hspec.QuickCheck (prop)

spec :: Spec
spec = do
    describe "from Maybe Selector" $ do
        it "select" $
            select (Just 1) Nothing `shouldBe` (Just 1 :: Maybe Int)
        it "empty" $
            empty `shouldBe` (Nothing :: Maybe Int)
        prop "select Nothing (Just x) is (Just x)" $
            \(x :: Maybe Int) -> select Nothing x `shouldBe` x
        prop "select (Just x) y is (Just x)" $
            \(x :: Int, y :: Maybe Int) -> select (Just x) y `shouldBe` Just x
    describe "from List Selector" $ do
        it "select" $
            select [1, 2, 3] [4, 5, 6] `shouldBe` ([1, 2, 3, 4, 5, 6] :: [Int])
        it "empty" $
            empty `shouldBe` ([] :: [Int])
        prop "select [] [xs] is [xs]" $
            \(xs :: [Int]) -> select [] xs `shouldBe` xs
        prop "select [xs] [] is [xs]" $
            \(xs :: [Int]) -> select xs [] `shouldBe` xs
