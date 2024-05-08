module FuncTypeSpec
  ( spec
  ) where

import           FuncType              (Func (..), apply, compose)
import           Test.Hspec            (Spec, describe, shouldBe)
import           Test.Hspec.QuickCheck (prop)

-- | Double an integer. (Inverse of 'g'.)
f :: Int -> Int
f = (* 2)

-- | Helper function Type for 'f'.
f' :: Func Int Int
f' = Func f

-- | Half an integer. (Inverse of 'f'.)
g :: Int -> Int
g = flip div 2

-- | Helper function Type for 'g'.
g' :: Func Int Int
g' = Func g

spec :: Spec
spec =
  describe "FuncType" $ do
    prop "apply f" $ \x -> apply f' x `shouldBe` f x
    prop "apply g" $ \x -> apply g' x `shouldBe` g x
    prop "compose f g is identity" $ \x -> apply (compose f' g') x `shouldBe` x
    prop "compose f g" $ \x -> apply (compose f' g') x `shouldBe` (g . f) x
