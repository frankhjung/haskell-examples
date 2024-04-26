{-|
Module      : Contravariant
Description : Explore contravariant functors.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

From
<https://www.schoolofhaskell.com/user/commercial/content/covariance-contravariance Covariance, contravariance, and positive and negative position>
and
<https://stackoverflow.com/questions/38034077/what-is-a-contravariant-functor What is a contravariant functor?>

The implementation of the function-result `fmap` and the function-argument
`contramap` are almost exactly the same thing: just function composition
(the `.` operator). The only difference is on which side you compose the
adaptor function

@
fmap :: (r -> s) -> (a -> r) -> (a -> s)
fmap adaptor f = adaptor . f
fmap adaptor = (adaptor .)
fmap = (.)

contramap' :: (b -> a) -> (a -> r) -> (b -> r)
contramap' adaptor f = f . adaptor
contramap' adaptor = (. adaptor)
contramap' = flip (.)
@

Note that `contramap'` is not the same as `contramap` from
`Data.Functor.Contravariant`. As you can't make a '-> r' an actual instance of
Contravariant in Haskell code simply because the 'a' is not the last type
parameter of ('->'). Conceptually it works perfectly well, and you can always
use a newtype wrapper to swap the type parameters and make that an instance
(the contravariant defines the the `Op` type for exactly this purpose).

-}

module Contravariant (
    -- * Types
    MakeString (..)
    -- * Functions
  , plus3ShowInt
  , showInt
) where

import           Data.Functor.Contravariant (Contravariant (..))

-- | A contravariant functor.
newtype MakeString a = MakeString { makeString :: a -> String }

-- | Map covariant functor over 'MakeString'.
instance Contravariant MakeString where
  contramap f (MakeString g) = MakeString (g . f)

-- | Show an integer.
showInt :: MakeString Int
showInt = MakeString show

-- | Show an integer plus 3.
-- Compare this with the following code:
-- @
-- plus3ShowInt = MakeString (show . (+ 3))
-- @
-- The `contramap` function is a more general way to compose the function.
plus3ShowInt :: MakeString Int
plus3ShowInt = contramap (+3) showInt

-- How to deal wit newtypes:
-- @
-- newtype Mark = MkMark Int deriving Show
-- incMark (MkMark a) = MkMark (a + 1)
-- x = MkMark 12        -- x :: Mark = MkMark 12
-- y = incMark x        -- y :: Mark = MkMark 13
-- @
