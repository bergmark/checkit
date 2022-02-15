module Types.CreateTodo where

import LocalPrelude

import Types.TodoFields

data CreateTodo = CreateTodo
  { projectId :: ProjectId
  , text :: TodoText
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)
