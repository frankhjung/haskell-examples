{-|

Module      : PrefixSumsSpec
Description : Test prefix sums.

__Notes__

The Sum monoid is defined by the numerical addition operator and `0` as
the neutral element.

See https://hackage.haskell.org/package/base/docs/Data-Monoid.html
-}

module PrefixSumsSpec (
    spec
  ) where

import           Control.Exception (evaluate)
import           Data.Array        (Array, listArray)
import           Data.Monoid       (Sum (..))
import           PrefixSums        (prefix, range)
import           Test.Hspec        (Spec, describe, errorCall, it, shouldBe,
                                    shouldThrow)

-- Test prefix sums
prefixSum :: Array Int (Sum Int)
prefixSum = prefix [Sum 1, Sum 2, Sum 3, Sum 4]

spec :: Spec
spec =
  describe "prefix" $ do
    it "computes the prefix sums of an empty list" $
      prefix ([] :: [Sum Int])
        `shouldBe` listArray (0, 0) [Sum 0]
    it "computes the prefix sums of a list of numbers" $
      prefix ([Sum 1, Sum 2, Sum 3, Sum 4] :: [Sum Int])
        `shouldBe` listArray (0, 4) [Sum 0, Sum 1, Sum 3, Sum 6, Sum 10]
    it "computes the range sums of a list of numbers" $
      range prefixSum 1 2 `shouldBe` Sum 3    -- sums: 1, 2
    it "computes the range sums for full list" $
      range prefixSum 1 4 `shouldBe` Sum 10   -- sums: 1, 2, 3, 4
    it "computes the range sums for a single element" $
      range prefixSum 2 2 `shouldBe` Sum 2    -- sums: 2
    it "invalid i indices throws an error" $
      evaluate (range prefixSum 0 2) `shouldThrow` errorCall "range: invalid indices"
    it "invalid j indices throws an error" $
      evaluate (range prefixSum 1 5) `shouldThrow` errorCall "range: invalid indices"
