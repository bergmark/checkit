{-# LANGUAGE ScopedTypeVariables #-}
module Db.Report where

import LocalPrelude hiding (filter, id)

import GHC.Int
import Hasql.Connection (Connection)
import Rel8 hiding (schema, insert)
import qualified Rel8 as R

import Db
import Types.Report qualified as Model
import Types.ReportFields
import Types.TodoFields

data Report f = Report
  { reportId :: Column f ReportId
  , todoId :: Column f TodoId
  , timestamp :: Column f UTCTime
  }
  deriving stock (Generic)
  deriving anyclass (Rel8able)

deriving stock instance f ~ Result => Show (Report f)

instance FromDb (Report Result) Model.Report where
  fromDb Report { reportId, todoId, timestamp } = Model.Report { reportId, todoId, timestamp }

schema :: TableSchema (Report Name)
schema = TableSchema
  { name = "todo"
  , schema = Nothing
  , columns = namesFromLabels @(Report Name)
  }

listByTodo_ :: Expr TodoId -> Query (Report Expr)
listByTodo_ tid = filter ((==.) tid . todoId) =<< each schema

byId :: Expr ReportId -> Query (Report Expr)
byId rid = filter ((==.) rid . reportId) =<< each schema

listByTodo :: MonadIO m => Connection -> TodoId -> m [Report Result]
listByTodo conn = liftIO . select conn . listByTodo_ . litExpr

selectById :: MonadIO m => Connection -> ReportId -> m (Maybe (Report Result))
selectById conn = liftIO . fmap listToMaybe . select conn . byId . litExpr

insert :: MonadIO m => Connection -> Report Result -> m Int64
insert conn todo = liftIO $ R.insert conn Insert
  { rows = [lit todo]
  , onConflict = Abort
  , returning = NumberOfRowsAffected
  , into = schema
  }
