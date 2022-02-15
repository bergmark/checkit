module Api where

import LocalPrelude

import Servant.API hiding (Capture, Delete, Get, Post, Put)
import Servant.API qualified as Servant

import Types
import Types.Error

type Delete o = UVerb 'DELETE '[JSON] o

type Get o = UVerb 'GET '[JSON] o

type Post i o = ReqBody '[JSON] i :> UVerb 'POST '[JSON] o

type Put i o = ReqBody '[JSON] i :> UVerb 'PUT '[JSON] o

type Capture t = Servant.Capture (ParamSym t) t

type Api
  =    "project" :> Get '[ProjectList]
  :<|> "project" :> Post CreateProject '[Project]
  :<|> "project" :> Capture ProjectId :> Get '[Project, ProjectNotFound]
  :<|> "project" :> Capture ProjectId :> "todo" :> Get '[TodoList, ProjectNotFound]
  :<|> "todo" :> Post CreateTodo '[Todo]
  :<|> "todo" :> Capture TodoId :> Get '[Todo, TodoNotFound]
  :<|> "todo" :> Post CreateReport '[Report]
  :<|> "todo" :> Capture ReportId :> Get '[Report, ReportNotFound]

api :: Proxy Api
api = Proxy
