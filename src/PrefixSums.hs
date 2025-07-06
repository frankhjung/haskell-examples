{-|

Module      : PrefixSums
Description : How to compute prefix sums in Haskell.
Copyright   : © Frank Jung, 2025
License     : GPL-3.0-only

Suppose we have a static sequence of values @a1, a2, ...@, an drawn from
some group, and want to be able to compute the total value (according to
the group operation) of any contiguous subrange. That is, given a range
@[i, j]@, we want to compute a value @ai + ai+1 + ... + aj@. For example,
we might have a sequence of integers and want to compute the sum, or
perhaps the bitwise xor (but not the maximum) of all the values in any
particular subrange.

Of course, we could simply compute @a1 + a2 + ... + aj@ directly, but that
takes O(n) time. With some simple preprocessing, it’s possible to compute
the value of any range in constant time.

The key idea is to compute the prefix sums of the values in the sequence.
@Pi = a1 + a2 + ... + ai@. Then, the value of any range @[i, j]@ just
compute @Pj - inv P(i-1)@ - that is, we start with a prefix that ends at
the right place, then cancel or "subtract" the prefix that ends right
before the range we want.

From blog by Brent Yorgey [Competitive programming in Haskell: prefix
sums](https://byorgey.github.io/blog/posts/2025/06/27/prefix-sums.html).

== Examples

The prefix sums of the list @[1, 2, 3, 4]@ is @[0, 1, 3, 6, 10]@:

@
prefix [Sum 1, Sum 2, Sum 3, Sum 4] = [Sum 0, Sum 1, Sum 3, Sum 6, Sum 10]
@

The range sum of the elements at indices 1 and 2 is 3:

@
range (prefix [Sum 1, Sum 2, Sum 3, Sum 4]) 1 2 = Sum 3
@

== Notes on Tests

The
[Sum](https://hackage.haskell.org/package/base/docs/Data-Monoid.html#t:Sum)
monoid is defined by the numerical addition operator and @0@ as the neutral
element.

For more see
[Data.Monoid](https://hackage.haskell.org/package/base/docs/Data-Monoid.html).

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
module PrefixSums
  (
    prefix
  , range
  , safeRange
  , safeRangeSum
  ) where

import           Data.Array (Array, bounds, listArray, (!))
import           Data.Group (Group (..), invert)
import           Data.List  (scanl')

-- | Pre-compute the prefix sums of a list of
-- [monoids](https://wiki.haskell.org/Monoid).
prefix :: Monoid a => [a]             -- ^ list to compute the prefix sums for
                      -> Array Int a  -- ^ array of prefix sums
prefix as = listArray (0, length as) (scanl' (<>) mempty as)

-- | Compute the prefix sums for a list, starting with a given value.
-- Here the list is 1 not 0 indexed.
range :: Group a => Array Int a -- ^ array of Prefix Sums
                      -> Int    -- ^ index @i@ of the first element (1 indexed)
                      -> Int    -- ^ index @j@ of the last element
                      -> a      -- ^ the sum of the range @[i, j]@
range p i j
    | i < 1 || j < i || j > bound = error "range: invalid indices"
    | otherwise                      = p!j <> invert (p!(i-1))
    where bound = snd (bounds p)

-- | Safe version that returns Maybe instead of throwing errors
safeRange :: Group a => Array Int a  -- ^ array of Prefix Sums
                          -> Int     -- ^ index @i@ of the first element (1 indexed)
                          -> Int     -- ^ index @j@ of the last element
                          -> Maybe a -- ^ the sum of the range @[i, j]@
safeRange p i j
    | i < 1 || j < i || j > bound = Nothing
    | otherwise                      = Just (p!j <> invert (p!(i-1)))
    where bound = snd (bounds p)

-- | Compute range sum directly from the original list
safeRangeSum :: Group a => [a]           -- ^ list of Prefix Sums
                          -> Int     -- ^ index @i@ of the first element (1 indexed)
                          -> Int     -- ^ index @j@ of the last element
                          -> Maybe a -- ^ the sum of the range @[i, j]@
safeRangeSum xs = safeRange (prefix xs)
