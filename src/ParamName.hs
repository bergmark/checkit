module ParamName
  ( ParamName(..)
  ) where

import LocalPrelude ()

import Data.Kind
import GHC.TypeLits

class ParamName (t :: Type) where
  type ParamSym t :: Symbol
