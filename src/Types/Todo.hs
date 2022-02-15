{-# LANGUAGE UndecidableInstances #-}
module Types.Todo where

import LocalPrelude

import Types.TodoFields

data Todo = Todo
  { projectId :: ProjectId
  , todoId :: TodoId
  , text :: TodoText
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)
    deriving HasStatus via WithStatus 200 Todo
