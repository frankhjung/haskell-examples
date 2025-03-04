{-# LANGUAGE DeriveFunctor        #-}
{-# LANGUAGE DerivingStrategies   #-}
{-# LANGUAGE UndecidableInstances #-}

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

-- | The functor for the arithmetic language.
data ArithF x = Add Int x | Sub Int x | Mul Int x | Div Int x deriving (Show, Functor)

-- | The free monad for the arithmetic language.
type ArithM = Free ArithF

-- | Evaluate an arithmetic expression.
evalArith :: Free ArithF Int -> Int
evalArith (Free (Add x n)) = evalArith n + x
evalArith (Free (Sub x n)) = evalArith n - x
evalArith (Free (Mul x n)) = evalArith n * x
evalArith (Free (Div x n)) = evalArith n `div` x
evalArith (Pure x)         = x

addA :: Int -> ArithM ()
addA x = liftF (Add x ())

subA :: Int -> ArithM ()
subA x = liftF (Sub x ())

mulA :: Int -> ArithM ()
mulA x = liftF (Mul x ())

divA :: Int -> ArithM ()
divA x = liftF (Div x ())

-- @evalArith (example 0) == 5@         # ((((0+10)*2)-10)/2) == 5
example :: Int -> ArithM Int
example n =
    divA 2
    >> subA 10
    >> mulA 2
    >> addA 10
    >> return n

-- @evalArith (exampleDo 1) == 6@       # ((((1+10)*2)-10)/2) == 6
exampleDo :: Int -> ArithM Int
exampleDo n = do
  divA 2
  subA 10
  mulA 2
  addA 10
  return n
