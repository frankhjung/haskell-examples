{-|
Module      : Contravariant
Description : Explore contravariant functors.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

This module explores the concept of contravariant functors in Haskell,
contrasting them with the more common covariant functors. It uses the
'MakeString' newtype as a concrete example.

From [Covariance, contravariance, and positive and negative
position](https://www.schoolofhaskell.com/user/commercial/content/covariance-contravariance)
and [What is a contravariant
functor?](https://stackoverflow.com/questions/38034077/what-is-a-contravariant-functor)

The implementation of the function-result 'fmap' and the function-argument
'contramap' are almost exactly the same thing: just function composition
(the '.' operator). The only difference is on which side you compose the
adapter function.

@
fmap :: (r -> s) -> (a -> r) -> (a -> s)
fmap adapter f = adapter . f
fmap adapter = (adapter .)
fmap = (.)

contramap' :: (b -> a) -> (a -> r) -> (b -> r)
contramap' adapter f = f . adapter
contramap' adapter = (. adapter)
contramap' = flip (.)
@

Note that 'contramap'' is not the same as 'contramap' from
'Data.Functor.Contravariant'. You cannot make '(->) r' an actual instance of
'Contravariant' in Haskell code simply because the 'a' is not the last type
parameter of '(->)'. Conceptually it works perfectly well, and you can always
use a newtype wrapper to swap the type parameters and make that an instance
(the contravariant package defines the 'Op' type for exactly this purpose).

-}

module Contravariant
  (
    -- * Types
    MakeString (..)
    -- * Functions
  , plus3ShowInt
  , showInt
  ) where

import           Data.Functor.Contravariant (Contravariant (..))

-- | A wrapper for a function that turns a type into a 'String'.
--
-- This is a classic example of a contravariant functor.
newtype MakeString a = MakeString { makeString :: a -> String }

-- | Map a function over the input of a 'MakeString'.
instance Contravariant MakeString where
  contramap f (MakeString g) = MakeString (g . f)

-- | A 'MakeString' that uses the 'Show' instance of 'Int'.
--
-- >>> makeString showInt 42
-- "42"
showInt :: MakeString Int
showInt = MakeString show

-- | A 'MakeString' that adds 3 to an 'Int' before showing it.
--
-- >>> makeString plus3ShowInt 10
-- "13"
--
-- This is equivalent to:
--
-- @
-- plus3ShowInt = MakeString (show . (+ 3))
-- @
--
-- The 'contramap' function provides a more general way to compose the
-- transformation.
plus3ShowInt :: MakeString Int
plus3ShowInt = contramap (+3) showInt

-- How to deal with newtypes:
--
-- @
-- newtype Mark = MkMark Int deriving Show
-- incMark (MkMark a) = MkMark (a + 1)
-- x = MkMark 12        -- x :: Mark = MkMark 12
-- y = incMark x        -- y :: Mark = MkMark 13
-- @
