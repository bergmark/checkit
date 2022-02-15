module Types.CreateReport where

import LocalPrelude

import Types.TodoFields

data CreateReport = CreateReport
  { todoId :: TodoId
  , timestamp :: UTCTime
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)
