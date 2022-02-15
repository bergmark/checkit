module Types.TodoFields (module Types.TodoFields, ProjectId) where

import LocalPrelude

import Types.ProjectFields (ProjectId)

newtype TodoId = TodoId { unTodoId :: UUID }
  deriving stock (Eq, Show, Generic)
  deriving (Hashable, ToJSON, FromJSON, FromHttpApiData, ToHttpApiData, DBEq, DBType) via UUID

instance ParamName TodoId where
  type ParamSym TodoId = "todoId"

newTodoId :: MonadIO m => m TodoId
newTodoId = TodoId <$> liftIO randomIO

newtype TodoText = TodoText { unTodoText :: Text }
  deriving stock (Eq, Show, Generic)
  deriving (Hashable, ToJSON, FromJSON, FromHttpApiData, ToHttpApiData, DBEq, DBType) via Text
