module Api where

import LocalPrelude

import Servant.API hiding (Capture, Delete, Get, Post, Put)
import Servant.API qualified as Servant

import ParamName
import Types

type Delete o = UVerb 'DELETE '[JSON] o

type Get o = UVerb 'GET '[JSON] o

type Post i o = ReqBody '[JSON] i :> UVerb 'POST '[JSON] o

type Put i o = ReqBody '[JSON] i :> UVerb 'PUT '[JSON] o

type Capture t = Servant.Capture (ParamSym t) t

type Api
  =    "project" :> Get '[ProjectList]
  :<|> "project" :> Post CreateProject '[Project]
  :<|> "project" :> Capture ProjectId :> Get '[Project]

api :: Proxy Api
api = Proxy
