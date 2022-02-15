module Types.Report where

import LocalPrelude

import Types.TodoFields
import Types.ReportFields

data Report = Report
  { reportId :: ReportId
  , todoId :: TodoId
  , timestamp :: UTCTime
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

instance HasStatus Report where
  type StatusOf Report = 200
