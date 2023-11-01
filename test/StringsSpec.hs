module StringsSpec
  ( spec
  ) where

import           Strings    (CharList (..), removeNonUpperCase)
import           Test.Hspec (Spec, describe, it, shouldBe)

spec :: Spec
spec = do
    describe "removeNonUpperCase" $ do
        it "replace special characters" $
            removeNonUpperCase "@#$%^&*()!" `shouldBe` ""
        it "should return empty" $
            removeNonUpperCase "zywqotx" `shouldBe` ""
        it "should remove non-upper case characters" $
            removeNonUpperCase "^ABcdeF$" `shouldBe` "ABF"
        it "should return input string" $
            removeNonUpperCase "ZYWQOTX" `shouldBe` "ZYWQOTX"
    describe "CharList" $
        it "should show CharList" $
            show (CharList "foo bar") `shouldBe` "CharList {getCharList = \"foo bar\"}"
