module FuncTypeSpec
  ( spec
  ) where

import           FuncType              (Func (..), apply, compose)
import           Test.Hspec            (Spec, describe)
import           Test.Hspec.QuickCheck (prop)

-- | Double an integer.
f :: Int -> Int
f = (* 2)

-- | Function Type for 'g'.
f' :: Func Int Int
f' = Func f

-- | Half an integer.
g :: Int -> Int
g = flip div 2

-- | Function Type for 'f'.
g' :: Func Int Int
g' = Func g

spec :: Spec
spec =
  describe "FuncType" $ do
    prop "apply f" $ \x -> apply f' x == f x
    prop "apply g" $ \x -> apply g' x == g x
    prop "compose f g is identity" $ \x -> apply (compose f' g') x == x
    prop "compose f g" $ \x -> apply (compose f' g') x == (g . f) x
