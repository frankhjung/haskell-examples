{-# LANGUAGE DeriveFunctor        #-}
{-# LANGUAGE DerivingStrategies   #-}
{-# LANGUAGE UndecidableInstances #-}

{-|

Module      : MyFreeMonad
Description : A simple arithmetic language implemented using a free monad.

Free monads in Haskell are a powerful abstraction that allows for the
creation of monadic structures without imposing additional constraints
beyond those required by the monad definition. They are "free" in the sense
that they are unrestricted, meaning they do not add any extra laws or
structure beyond what is necessary for a monad.

A free monad satisfies all the Monad laws, but does not do any computation.
It just builds up a nested series of contexts. The user who creates such a
free monadic value is responsible for doing something with those nested
contexts, so that the meaning of such a composition can be deferred until
after the monadic value has been created.

Example usage:

>>> evalArith (example 0)
5

-}
module MyFreeMonad ( ArithM
                   , ArithF (..)
                   , addA
                   , subA
                   , mulA
                   , divA
                   , evalArith
                   , example
                   , exampleDo
                   ) where

import           Control.Monad.Free (Free (..), liftF)

-- | The functor for the arithmetic language, defining the supported operations.
data ArithF x
  = Add Int x -- ^ Addition operation
  | Sub Int x -- ^ Subtraction operation
  | Mul Int x -- ^ Multiplication operation
  | Div Int x -- ^ Division operation
  deriving (Show, Functor)

-- | The free monad for the arithmetic language, built over the 'ArithF' functor.
type ArithM = Free ArithF

-- | Evaluate an arithmetic expression.
--
-- >>> evalArith (Pure 10)
-- 10
--
-- >>> evalArith (example 1)
-- 6
evalArith :: Free ArithF Int -> Int
evalArith (Free (Add x n)) = evalArith n + x
evalArith (Free (Sub x n)) = evalArith n - x
evalArith (Free (Mul x n)) = evalArith n * x
evalArith (Free (Div x n)) = evalArith n `div` x
evalArith (Pure x)         = x

-- | Lift an addition operation into the 'ArithM' monad.
addA :: Int -> ArithM ()
addA x = liftF (Add x ())

-- | Lift a subtraction operation into the 'ArithM' monad.
subA :: Int -> ArithM ()
subA x = liftF (Sub x ())

-- | Lift a multiplication operation into the 'ArithM' monad.
mulA :: Int -> ArithM ()
mulA x = liftF (Mul x ())

-- | Lift a division operation into the 'ArithM' monad.
divA :: Int -> ArithM ()
divA x = liftF (Div x ())

-- | An example arithmetic computation.
--
-- >>> evalArith (example 0)
-- 5
example :: Int -> ArithM Int
example n =
    divA 2
    >> subA 10
    >> mulA 2
    >> addA 10
    >> return n

-- | An example arithmetic computation using do-notation.
--
-- >>> evalArith (exampleDo 1)
-- 6
exampleDo :: Int -> ArithM Int
exampleDo n = do
  divA 2
  subA 10
  mulA 2
  addA 10
  return n
