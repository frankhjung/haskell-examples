{-|

Module      : ShowFile
Description : Effective Haskell exercises, Chapter 7 Understanding IO.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

-}

module ShowFile (
    noPasswd
  , showFile
  , makeAndReadFile
  , makeAndShow
  , safeIO
  ) where

-- | Show path except if `/etc/passwd`.
-- Better as an Either, filename or "invalid file error".
noPasswd :: FilePath -> IO String
noPasswd path
  | path == "/etc/passwd" = return "no passwd"
  | otherwise = return path

-- | Show file content.
showFile :: FilePath -> IO String
showFile = noPasswd

-- | Make and read a file.
-- Write and then read a file.
makeAndReadFile :: Int -> IO String
makeAndReadFile fnumber =
  let fname = "/tmp/test-" <> show fnumber
  in writeFile fname fname >> readFile fname

-- | Make and show file helper function.
-- Write and read a file.
makeAndShow :: Int -> IO ()
makeAndShow n = makeAndReadFile n >>= putStrLn

-- | Test writing and reading a number of files.
-- Efficient sequencing of IO actions ensuring file handle is closed.
safeIO :: Int -> IO ()
safeIO n
  | n > 0 && n < 100000 = mapM_ makeAndShow [1..n]
  | otherwise = error "Must be a positive number between 1 and 100,000."
