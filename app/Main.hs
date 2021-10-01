{-# LANGUAGE DerivingStrategies #-}

module Main ( main, removeNonUpperCase, CharList(..) ) where

import           Test.Hspec (describe, hspec, it, shouldBe)


-- remove non upper case characters
-- >>> removeNonUpperCase("ABcdeF")
-- "ABF"
removeNonUpperCase :: String -> String
removeNonUpperCase s = [c | c <- s, c `elem` ['A' .. 'Z']]

-- new types
-- >>> CharList "this will be shown!"
-- CharList {getCharList = "this will be shown!"}
-- >>> CharList "benny" == CharList "benny"
-- True
-- >>> CharList "benny" == CharList "andy"
-- False
newtype CharList = CharList {getCharList :: String} deriving (Eq, Show)


main :: IO ()
main = hspec $ do
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
