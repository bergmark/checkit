module Types.TodoList where

import LocalPrelude

import Types.Todo

data TodoList = TodoList
  { todos :: [Todo]
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

instance HasStatus TodoList where
  type StatusOf TodoList = 200

emptyTodoList :: TodoList
emptyTodoList = TodoList { todos = [] }
