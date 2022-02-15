{-# LANGUAGE ScopedTypeVariables #-}
module Db.Project where

import LocalPrelude hiding (filter, id)

import GHC.Int
import Hasql.Connection (Connection)
import Rel8 hiding (schema, insert, name)
import qualified Rel8 as R

import Db
import Types.Project qualified as Model
import Types.ProjectFields

data Project f = Project
  { projectId :: Column f ProjectId
  , name :: Column f ProjectName
  }
  deriving stock (Generic)
  deriving anyclass (Rel8able)

deriving stock instance f ~ Result => Show (Project f)

instance FromDb (Project Result) Model.Project where
  fromDb Project { projectId, name } = Model.Project { projectId, name }

schema :: TableSchema (Project Name)
schema = TableSchema
  { R.name = "project"
  , R.schema = Nothing
  , R.columns = namesFromLabels @(Project Name)
  }

listAll :: Query (Project Expr)
listAll = each schema

byId :: Expr ProjectId -> Query (Project Expr)
byId pid = filter (\p -> projectId p ==. pid) =<< each schema

list :: Connection -> IO [Project Result]
list conn = select conn listAll

selectById :: MonadIO m => Connection -> ProjectId -> m (Maybe (Project Result))
selectById conn = liftIO . fmap listToMaybe . select conn . byId . litExpr

insert :: MonadIO m => Connection -> Project Result -> m Int64
insert conn project = liftIO $ R.insert conn Insert
  { rows = [lit project]
  , onConflict = Abort
  , returning = NumberOfRowsAffected
  , into = schema
  }
