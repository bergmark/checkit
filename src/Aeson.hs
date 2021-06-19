module Aeson
  ( module Data.Aeson
  , aesonQQ
  , defaultOptions
  , encodePretty
  ) where

import LocalPrelude

import Text.Casing

import Data.Aeson hiding (defaultOptions)
import Data.Aeson.Encode.Pretty (encodePretty)
import Data.Aeson.QQ (aesonQQ)
import qualified Data.Aeson as A

defaultOptions :: Options
defaultOptions = A.defaultOptions
  { constructorTagModifier = quietSnake
  , rejectUnknownFields = True
  }
