{-|

Module      : PrefixSumsSpec
Description : Test prefix sums.

== Notes on Property Tests

The property-based tests verifies that the 'range' functions correctly
calculate sums of subranges for arbitrary lists:

@
it "works for arbitrary prefix lists (property-based test)" $
  property $ \(ys :: [Sum Int])(NonNegative i) (NonNegative j) ->
    let arr      = prefix (map Sum ys)
        n        = length ys
        low      = 1 + i `mod` max 1 n  -- ensure valid index
        high     = low + j `mod` max 0 (n - low + 1)
        expected = sum (drop (low - 1) (take high ys))
    in n > 0 ==> range arr low high == Sum expected
@

Breaking it down:

(1) __Input generation__

* @xs :: [Sum Int]@:
[QuickCheck](https://hackage-content.haskell.org/package/QuickCheck/docs/Test-QuickCheck.html)
generates random lists of
[Sum](https://hackage.haskell.org/package/base/docs/Data-Monoid.html#t:Sum)
[Monoid](https://hackage.haskell.org/package/base/docs/Data-Monoid.html#t:Monoid)
values
* @ys :: [Int]@: QuickCheck generates random integer lists
* @NonNegative i@ and @NonNegative j@: Random non-negative integers

2. __Variable setup__

* @arr = prefix (map Sum ys)@: @: Converts integers to 'prefix'
[Sum](https://hackage.haskell.org/package/base/docs/Data-Monoid.html#t:Sum)s
of
[Monoid](https://hackage.haskell.org/package/base/docs/Data-Monoid.html#t:Monoid)
values
* @arr = map Sum ys@: Converts integers to 'Sum' monoid values
* @n = length ys@: Gets list length
* @low = 1 + i mod max 1 n@: Creates a valid starting index (1-indexed)
* @high = low + j mod max 0 (n - low + 1)@: Creates a valid ending index ≥ low

3. __Expected result calculation__

* @expected = sum (drop (low - 1) (take high ys))@: Directly calculates the
sum by:

    * Taking first high elements
    * Dropping first @low-1@ elements
    * Summing the remainder

4. __Test condition__

* @n > 0 ==>@: Only test non-empty lists
* @rangeSum arr low high == Just (Sum expected)@: Verify function matches
direct calculation

This tests that the optimised 'rangeSum' implementation using 'prefix' sums
gives the same results as the straightforward direct calculation.

-}

module PrefixSumsSpec (
    spec
  ) where

import           Control.Exception (evaluate)
import           Data.Array        (listArray)
import           Data.Monoid       (Sum (..))
import           PrefixSums        (prefix, range, safeRange, safeRangeSum)
import           Test.Hspec        (Spec, describe, errorCall, it, shouldBe,
                                    shouldThrow)
import           Test.QuickCheck   (NonNegative (..), property, (==>))

spec :: Spec
spec = do
  let
    xs = [Sum 1, Sum 2, Sum 3, Sum 4]
    prefixSum = prefix xs

  describe "prefix" $ do
    it "computes the prefix sums of an empty list" $
      prefix ([] :: [Sum Int])
        `shouldBe` listArray (0, 0) [Sum 0]
    it "computes the prefix sums of a list of numbers" $
      prefix xs
        `shouldBe` listArray (0, 4) [Sum 0, Sum 1, Sum 3, Sum 6, Sum 10]

  describe "range" $ do
    it "computes the range sums of a list of numbers" $
      range prefixSum 1 2 `shouldBe` (Sum 3 :: Sum Int)
    it "computes the range sums for full list" $
      range prefixSum 1 4 `shouldBe` (Sum 10 :: Sum Int)
    it "computes the range sums for a single element" $
      range prefixSum 2 2 `shouldBe` (Sum 2 :: Sum Int)
    it "invalid i indices throws an error" $
      evaluate (range prefixSum 0 2) `shouldThrow` errorCall "range: invalid indices"
    it "invalid j indices throws an error" $
      evaluate (range prefixSum 1 5) `shouldThrow` errorCall "range: invalid indices"
    it "works for arbitrary prefix lists (property-based test)" $
      property $ \(ys :: [Sum Int])(NonNegative i) (NonNegative j) ->
        let arr      = prefix (map Sum ys)
            n        = length ys
            low      = 1 + i `mod` max 1 n  -- ensure valid index
            high     = low + j `mod` max 0 (n - low + 1)
            expected = sum (drop (low - 1) (take high ys))
        in n > 0 ==> range arr low high == Sum expected

  describe "safeRange" $ do
    it "computes the range sums of a list of numbers" $
      safeRange prefixSum 1 2 `shouldBe` Just (Sum 3 :: Sum Int)
    it "computes the range sums for full list" $
      safeRange prefixSum 1 4 `shouldBe` Just (Sum 10 :: Sum Int)
    it "computes the range sums for a single element" $
      safeRange prefixSum 2 2 `shouldBe` Just (Sum 2 :: Sum Int)
    it "invalid i indices returns Nothing" $
      safeRange prefixSum 0 2 `shouldBe` Nothing
    it "invalid j indices returns Nothing" $
      safeRange prefixSum 1 5 `shouldBe` Nothing

  describe "safeRangeSum" $ do
    it "computes the range sums of a list of numbers" $
      safeRangeSum xs 1 2 `shouldBe` Just (Sum 3 :: Sum Int)
    it "computes the range sums for full list" $
      safeRangeSum xs 1 4 `shouldBe` Just (Sum 10 :: Sum Int)
    it "computes the range sums for a single element" $
      safeRangeSum xs 2 2 `shouldBe` Just (Sum 2 :: Sum Int)
    it "invalid i indices returns Nothing" $
      safeRangeSum xs 0 2 `shouldBe` Nothing
    it "invalid j indices returns Nothing" $
      safeRangeSum xs 1 5 `shouldBe` Nothing

    it "works for arbitrary lists (property-based test)" $
      property $ \(ys :: [Int])(NonNegative i) (NonNegative j) ->
        let arr      = map Sum ys
            n        = length ys
            low      = 1 + i `mod` max 1 n  -- ensure valid index
            high     = low + j `mod` max 0 (n - low + 1)
            expected = sum (drop (low - 1) (take high ys))
        in n > 0 ==> safeRangeSum arr low high == Just (Sum expected)
