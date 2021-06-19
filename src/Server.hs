{-# OPTIONS -Wno-missing-exported-signatures #-}
{-# OPTIONS -Wno-missing-signatures #-}

module Server where

import LocalPrelude hiding (id)

import Network.Wai
import Network.Wai.Handler.Warp
import Servant

import Api
import Db qualified
import Types
import Types.ProjectFields
import Types.CreateProject
import Types.Project
import Types.ProjectList


server = projectList :<|> projectCreate :<|> projectGet

projectList :: Handler (Union '[ProjectList])
projectList = respond emptyProjectList

projectCreate :: CreateProject -> Handler (Union '[Project])
projectCreate CreateProject { name } = do
  id <- newProjectId
  _ <- liftIO . Db.withConnection $ \conn ->
    Db.insertProject conn Db.Project { id = id, name = name }
  respond Project { id, name }

projectGet :: ProjectId -> Handler (Union '[Project])
projectGet id = do
  project <- liftIO . Db.withConnection $ \conn -> Db.selectProjectById conn id
  case project of
    Nothing -> undefined
    Just Db.Project { id, name } ->
      respond $ Project { id, name }

app :: Application
app = serve api server

main :: IO ()
main = do
  putStrLn "Starting"
  run 3000 app
