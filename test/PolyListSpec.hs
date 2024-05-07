{-# LANGUAGE DataKinds    #-}
{-# LANGUAGE TypeFamilies #-}

module PolyListSpec (
    spec
  ) where

import           PolyList   (PolyList (..), pHead, pLength)
import           Test.Hspec (Spec, describe, it, shouldBe, shouldNotBe)

plist :: PolyList '[Maybe String, Bool, Int]
plist = Just "foo" :# True :# 42 :# Nil

plist' :: PolyList '[Maybe String, Bool, Int]
plist' = Just "bar" :# True :# 42 :# Nil

getBool :: PolyList '[_1, Bool, _2] -> Bool
getBool (_ :# b :# _) = b

spec :: Spec
spec =
  describe "PolyList" $ do
    it "pLength list" $
      pLength plist `shouldBe` 3
    it "pLength empty" $
      pLength Nil `shouldBe` 0
    it "pHead" $
      pHead plist `shouldBe` Just "foo"
    it "getBool" $
      getBool plist `shouldBe` True
    it "eq true" $
      (Just "foo" :# True :# 42 :# Nil) `shouldBe` plist
    it "eq false" $
      plist `shouldNotBe` plist'
    it "ord" $
      plist > plist' `shouldBe` True
