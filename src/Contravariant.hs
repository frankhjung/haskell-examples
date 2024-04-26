{-|
Module      : Contravariant
Description : Explore contravariant functors.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

From
<https://www.schoolofhaskell.com/user/commercial/content/covariance-contravariance Covariance, contravariance, and positive and negative position>
and
<https://stackoverflow.com/questions/38034077/what-is-a-contravariant-functor What is a contravariant functor?>

-}

module Contravariant (
    -- * Types
    MakeString (..)
    -- * Functions
  , mapMakeString
  , plus3ShowInt
  , showInt
) where

-- | A contravariant functor.
newtype MakeString a = MakeString { makeString :: a -> String }

-- | Map a function over a 'MakeString'.
mapMakeString :: (b -> a) -> MakeString a -> MakeString b
mapMakeString f (MakeString g) = MakeString (g . f)

-- | Show an integer.
showInt :: MakeString Int
showInt = MakeString show

-- | Show an integer plus 3.
plus3ShowInt :: MakeString Int
plus3ShowInt = mapMakeString (+3) showInt
