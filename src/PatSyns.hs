{-# LANGUAGE LambdaCase      #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE ViewPatterns    #-}
{-# OPTIONS_GHC -Wall #-}

{-|
Module      : PatSyns
Description : Pattern synonyms examples from TWEAG.
Copyright   : © Frank Jung, 2021-2023
License     : GPL-3.0-only

From Tweag YouTube channel
<https://youtu.be/SPC_R5nwFqo Introduction to Pattern Synonyms>
where Richard introduces GHC's feature of Pattern Synonyms, allowing programmers
to abstract over a pattern.

-}

module PatSyns
  ( Card (.., CJack, CQueen, CKing, CAce),
    Honor (..),
    checkEven,
    numCardsToPlay,
  ) where

import           Numeric.Natural (Natural)

-- | Enumerated Cards including 'Honor' cards.
data Card = C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 | C10 | CHonor Honor

-- | Honor cards.
data Honor = HJack | HQueen | HKing | HAce

-- | Show instance for 'Card' type.
-- >>> show [CJack, CQueen, CKing, CAce, C7]
-- "[J,Q,K,A,7]"
-- >>> show [CHonor HJack, CHonor HQueen, CHonor HKing, CHonor HAce, C7]
-- "[J,Q,K,A,7]"
-- Here we want to keep show instance with 'Card's even though the 'Card type
-- uses 'Honor' cards.
instance Show Card where
  show = \case
    C2     -> "2"
    C3     -> "3"
    C4     -> "4"
    C5     -> "5"
    C6     -> "6"
    C7     -> "7"
    C8     -> "8"
    C9     -> "9"
    C10    -> "10"
    CJack  -> "J"
    CQueen -> "Q"
    CKing  -> "K"
    CAce   -> "A"


-- Used to tell GHC that we have included all possible patterns.
{-# COMPLETE C2, C3, C4, C5, C6, C7, C8, C9, C10, CJack, CQueen, CKing, CAce #-}

-- | Pattern synonyms can be "bundled" into exported 'Card' type description.
pattern CJack :: Card
pattern CJack = CHonor HJack

pattern CQueen :: Card
pattern CQueen = CHonor HQueen

pattern CKing :: Card
pattern CKing = CHonor HKing

pattern CAce :: Card
pattern CAce = CHonor HAce

-- | Have provided all patterns (see COMPLETE above).
numCardsToPlay :: Honor -> Natural
numCardsToPlay HJack  = 1
numCardsToPlay HQueen = 2
numCardsToPlay HKing  = 3
numCardsToPlay HAce   = 4

-- | Another Example is to use a function to evaluate a pattern:
pattern Even :: Integral a => a
pattern Even <- (even -> True)

-- | Check if a integer value is or odd.
--
-- >>> checkEven 42
-- True
-- >>> checkEven 11
-- False
checkEven :: Int -> Bool
checkEven Even = True
checkEven _    = False
