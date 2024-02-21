{-|

Module      : ShowFile
Description : Effective Haskell exercise.
Copyright   : © Frank Jung, 2024
License     : GPL-3.0-only

-}

module ShowFile (
    noPasswd
  , showFile
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
