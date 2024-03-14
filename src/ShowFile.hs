{-|

Module      : ShowFile
Description : Effective Haskell exercises, Chapter 7 Understanding IO.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

-}

module ShowFile (
    noPasswd
  , showContent
  , makeAndReadFile
  , makeAndShow
  , safeIO
  , getFileInfo
  , showTime
  , parseTime
  -- * Types
  , FileInfo (..)
  ) where

import qualified Data.Time.Clock  as Clock
import           Data.Time.Format (defaultTimeLocale, formatTime, parseTimeM)
import qualified System.Directory as Dir

data FileInfo = FileInfo {
  _path  :: FilePath
, _size  :: Integer
, _mtime :: Clock.UTCTime
, _read  :: Bool
, _write :: Bool
, _exec  :: Bool
} deriving (Show)

-- | Show path except if `/etc/passwd`.
-- Better as an Either, filename or "invalid file error".
noPasswd :: FilePath -> IO String
noPasswd path
  | path == "/etc/passwd" = return "no passwd"
  | otherwise = return path

-- | Show file content.
showContent :: FilePath -> IO String
showContent = noPasswd

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

-- | Get file info.
getFileInfo :: FilePath -> IO FileInfo
getFileInfo filePath = do
  size <- Dir.getFileSize filePath
  mtime <- Dir.getModificationTime filePath
  perms <- Dir.getPermissions filePath
  return $ FileInfo {
    _path = filePath
  , _size = size
  , _mtime = mtime
  , _read = Dir.readable perms
  , _write = Dir.writable perms
  , _exec = Dir.executable perms
  }

-- | Helper function to convert UTCTime to ISO date string.
showTime :: Clock.UTCTime -> String
showTime = formatTime defaultTimeLocale "%Y-%m-%dT%T%Z"

-- | Helper function to convert ISO date string to UTCTime.
--
-- ISO date/time format string is "%Y-%m-%dT%T%Z"
--
-- Example: @"2023-11-22T04:27:27Z"@
parseTime :: String -> Maybe Clock.UTCTime
parseTime = parseTimeM True defaultTimeLocale "%Y-%m-%dT%T%Z"
