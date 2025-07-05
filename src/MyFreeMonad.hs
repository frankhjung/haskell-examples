{-# LANGUAGE DeriveFunctor        #-}
{-# LANGUAGE DerivingStrategies   #-}
{-# LANGUAGE UndecidableInstances #-}

{-|

Module      : MyFreeMonad
Description : Test free monad.

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
