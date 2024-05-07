{-# LANGUAGE ConstraintKinds      #-}
{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE ScopedTypeVariables  #-}
-- {-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE UndecidableInstances #-}

{-|
Module      : PolyList
Description : Polymorhic list.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

From Thinking with Types, Sandy Maguire, 2021, section 5.3 Heterogeneous Types.

-}

module PolyList (
    -- * Types
    PolyList (..)
    -- * Functions
  , pLength
  , pHead
) where

import           Data.Kind (Type)

data PolyList (ts :: [Type]) where
  Nil :: PolyList '[]
  (:#) :: t -> PolyList ts -> PolyList (t ': ts)
infixr 5 :#

instance Eq (PolyList '[]) where
  Nil == Nil = True

instance (Eq t, Eq (PolyList ts)) => Eq (PolyList (t ': ts)) where
  (a :# as) == (b :# bs) = a == b && as == bs

instance Ord (PolyList '[]) where
  Nil `compare` Nil = EQ

instance (Ord t, Ord (PolyList ts)) => Ord (PolyList (t ': ts)) where
  (a :# as) `compare` (b :# bs) = case compare a b of
    EQ -> as `compare` bs
    x  -> x

instance Show (PolyList '[]) where
  show Nil = "Nil"

instance (Show t, Show (PolyList ts)) => Show (PolyList (t ': ts)) where
    show (a :# as) = show a ++ " :# " ++ show as

-- | Get the length of a polymorphic list.
pLength :: PolyList ts -> Int
pLength Nil       = 0
pLength (_ :# ts) = 1 + pLength ts

-- | Get the head of a polymorphic list.
pHead :: PolyList (t ': ts) -> t
pHead (t :# _) = t
