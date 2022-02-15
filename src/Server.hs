{-# OPTIONS -Wno-missing-exported-signatures #-}
{-# OPTIONS -Wno-missing-signatures #-}

module Server where

import LocalPrelude hiding (id)

import Network.Wai
import Network.Wai.Handler.Warp
import Servant

import Api
import Api.UVerb
import Db (fromDb, runQuery)
import Db.Project qualified
import Db.Report qualified
import Db.Todo qualified
import Types
import Types.CreateProject
import Types.CreateReport
import Types.CreateTodo
import Types.Error
import Types.Project
import Types.ProjectFields
import Types.ProjectList
import Types.Report
import Types.ReportFields
import Types.Todo
import Types.TodoFields
import Types.TodoList


server = projectList :<|> projectCreate :<|> projectGet :<|> todoList :<|> todoCreate :<|> todoGet :<|> reportCreate :<|> reportGet

projectList :: Handler (Union '[ProjectList])
projectList = do
  projects <- runQuery Db.Project.list
  respond $ ProjectList { projects = fmap fromDb projects }

projectCreate :: CreateProject -> Handler (Union '[Project])
projectCreate CreateProject { name } = runUVerbT $ do
  projectId <- newProjectId
  _ <- runQuery $ flip Db.Project.insert Db.Project.Project { projectId = projectId, name }
  pure Project { projectId, name }

projectGet :: ProjectId -> Handler (Union '[Project, ProjectNotFound])
projectGet id = runUVerbT $ do
  fromDb <$> runQuery (flip Db.Project.selectById id) `orElse` throwUVerb ProjectNotFound

todoList :: ProjectId -> Handler (Union '[TodoList, ProjectNotFound])
todoList projectId = runUVerbT $ do
  _ <- runQuery (flip Db.Project.selectById projectId) `orElse` throwUVerb ProjectNotFound
  todos <- runQuery $ flip Db.Todo.listByProject projectId
  pure TodoList { todos = fmap fromDb todos }

todoCreate :: CreateTodo -> Handler (Union '[Todo])
todoCreate CreateTodo { projectId, text } = runUVerbT $ do
  todoId <- newTodoId
  _ <- runQuery $ flip Db.Todo.insert Db.Todo.Todo { projectId, todoId, text }
  pure Todo { projectId, todoId, text }

todoGet :: TodoId -> Handler (Union '[Todo, TodoNotFound])
todoGet id = runUVerbT $
  fromDb <$> runQuery (flip Db.Todo.selectById id) `orElse` throwUVerb TodoNotFound

reportCreate :: CreateReport -> Handler (Union '[Report])
reportCreate CreateReport { todoId, timestamp } = runUVerbT $ do
  reportId <- newReportId
  _ <- runQuery $ flip Db.Report.insert Db.Report.Report { reportId, todoId, timestamp }
  pure Report { reportId, todoId, timestamp }

reportGet :: ReportId -> Handler (Union '[Report, ReportNotFound])
reportGet id = runUVerbT $
  fromDb <$> runQuery (flip Db.Report.selectById id) `orElse` throwUVerb ReportNotFound

orElse :: Monad m => m (Maybe a) -> m a -> m a
orElse m err = maybe err pure =<< m

app :: Application
app = serve api server

main :: IO ()
main = do
  putStrLn "Starting"
  run 3000 app
