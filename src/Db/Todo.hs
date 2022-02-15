{-# LANGUAGE ScopedTypeVariables #-}
module Db.Todo where

import LocalPrelude hiding (filter, id)

import GHC.Int
import Hasql.Connection (Connection)
import Rel8 hiding (schema, insert)
import qualified Rel8 as R

import Db
import Types.Todo qualified as Model
import Types.TodoFields

data Todo f = Todo
  { projectId :: Column f ProjectId
  , todoId :: Column f TodoId
  , text :: Column f TodoText
  }
  deriving stock (Generic)
  deriving anyclass (Rel8able)

deriving stock instance f ~ Result => Show (Todo f)

instance FromDb (Todo Result) Model.Todo where
  fromDb Todo { projectId, todoId, text } = Model.Todo { projectId, todoId, text }

schema :: TableSchema (Todo Name)
schema = TableSchema
  { name = "todo"
  , schema = Nothing
  , columns = namesFromLabels @(Todo Name)
  }

listByProject_ :: Expr ProjectId -> Query (Todo Expr)
listByProject_ pid = filter ((==.) pid . projectId) =<< each schema

byId :: Expr TodoId -> Query (Todo Expr)
byId tid = filter ((==.) tid . todoId) =<< each schema

listByProject :: MonadIO m => Connection -> ProjectId -> m [Todo Result]
listByProject conn = liftIO . select conn . listByProject_ . litExpr

selectById :: MonadIO m => Connection -> TodoId -> m (Maybe (Todo Result))
selectById conn = liftIO . fmap listToMaybe . select conn . byId . litExpr

insert :: MonadIO m => Connection -> Todo Result -> m Int64
insert conn todo = liftIO $ R.insert conn Insert
  { rows = [lit todo]
  , onConflict = Abort
  , returning = NumberOfRowsAffected
  , into = schema
  }
