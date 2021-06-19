module LocalPrelude
  ( module Prelude

  , module Control.Monad
  , module Control.Monad.IO.Class
  , module Data.ByteString.Lazy
  , module Data.HashMap.Strict
  , module Data.HashSet
  , module Data.Hashable
  , module Data.Maybe
  , module Data.Proxy
  , module Data.String.Conversions
  , module Data.String.Conversions.Monomorphic
  , module Data.Text
  , module GHC.Generics
  , module GHC.Stack
  ) where

import Prelude hiding (writeFile)

import Control.Monad
import Control.Monad.IO.Class
import Data.ByteString.Lazy (ByteString)
import Data.HashMap.Strict (HashMap)
import Data.HashSet (HashSet)
import Data.Hashable (Hashable)
import Data.Maybe
import Data.Proxy
import Data.String.Conversions hiding (LazyByteString, StrictText)
import Data.String.Conversions.Monomorphic
import Data.Text (Text)
import GHC.Generics (Generic, Rep)
import GHC.Stack (HasCallStack)
