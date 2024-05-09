{-# LANGUAGE DataKinds    #-}
{-# LANGUAGE TypeFamilies #-}

module PolyListSpec (
    spec
  ) where

import           PolyList   (HEntry (..), PolyList (..), pHead, pLength)
import           Test.Hspec (Spec, describe, it, shouldBe, shouldNotBe)

-- | Get the 2nd element as a Boolean from a polymorphic list.
getBool :: PolyList '[ _1, Bool, _2] -> Bool
getBool (_ :# b :# _) = b

plist :: PolyList '[Maybe String, Bool, Int]
plist = Just "foo" :# True :# 42 :# PNil

plist' :: PolyList '[Maybe String, Bool, Int]
plist' = Just "bar" :# False :# 41 :# PNil

hlist :: [HEntry]
hlist = [HEntry (1 :: Int), HEntry ("hello" :: String), HEntry 'c']

spec :: Spec
spec =
  describe "PolyList" $ do
    it "pLength list" $
      pLength plist `shouldBe` 3
    it "pLength empty" $
      pLength PNil `shouldBe` 0
    it "pHead" $
      pHead plist `shouldBe` Just "foo"
    it "getBool" $
      getBool plist `shouldBe` True
    it "show" $
      show plist `shouldBe` "Just \"foo\" :# True :# 42 :# PNil"
    it "eq" $
      (Just "foo" :# True :# 42 :# PNil) `shouldBe` plist
    it "not eq" $
      plist' `shouldNotBe` plist
    it "ord eq" $
      plist `compare` plist `shouldBe` EQ
    it "ord gt" $
      plist `compare` plist' `shouldBe` GT
    it "length of HEntry list" $
      length hlist `shouldBe` 3
