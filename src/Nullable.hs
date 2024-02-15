{-|

Module      : Nullable
Description : Effective Haskell exercise.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

-}
module Nullable (
    Nullable (..)
  ) where

import           Data.Maybe (isNothing)
import           Prelude    hiding (null)
import qualified Prelude    (null)

class Nullable a where
  isNull :: a -> Bool
  null :: a

instance Nullable (Maybe a) where
  isNull = isNothing
  null = Nothing

instance Nullable [a] where
  isNull = Prelude.null
  null = []
