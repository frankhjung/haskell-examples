{-|

Module      : PrefixSums
Description : How to compute prefix sums in Haskell.
Copyright   : © Frank Jung, 2025
License     : GPL-3.0-only

Suppose we have a static sequence of values a1, a2, ... , an drawn from
some group, and want to be able to compute the total value (according to
the group operation) of any contiguous subrange. That is, given a range [i,
j], we want to compute a value ai + ai+1 + ... + aj. For example, we might
have a sequence of integers and want to compute the sum, or perhaps the
bitwise xor (but not the maximum) of all the values in any particular
subrange.

Of course, we could simply compute a1 + a2 + ... + aj directly, but that
takes O(n) time. With some simple preprocessing, it’s possible to compute
the value of any range in constant time.

The key idea is to compute the prefix sums of the values in the sequence.
Pi = a1 + a2 + ... + ai. Then, the value of any range [i, j] just compute
Pj - inv P(i-1) - that is, we start with a prefix that ends at the right
place, then cancel or "subtract" the prefix that ends right before the
range we want.

From https://byorgey.github.io/blog/posts/2025/06/27/prefix-sums.html

__Examples__

The prefix sums of the list [1, 2, 3, 4] is [0, 1, 3, 6, 10]:

@
prefix [Sum 1, Sum 2, Sum 3, Sum 4] = [Sum 0, Sum 1, Sum 3, Sum 6, Sum 10]
@

The range sum of the elements at indices 1 and 2 is 3:

@
range (prefix [Sum 1, Sum 2, Sum 3, Sum 4]) 1 2 = Sum 3
@

-}
module PrefixSums
  (
    prefix
  , range
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
                      -> Int    -- ^ (i) index of the first element (1 indexed)
                      -> Int    -- ^ (j) index of the last element
                      -> a      -- ^ the sum of the range [i, j]
range p i j
    | i < 1 || j < i || j > snd (bounds p) = error "range: invalid indices"
    | otherwise                             = p!j <> invert (p!(i-1))
