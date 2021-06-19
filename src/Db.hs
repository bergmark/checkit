module Db where

import LocalPrelude hiding (filter, id)

import GHC.Int
import Hasql.Connection (Connection)
import Hasql.Connection qualified as C
import Rel8

import Types.ProjectFields

data Project f = Project
  { id   :: Column f ProjectId
  , name :: Column f ProjectName
  }
  deriving stock (Generic)
  deriving anyclass (Rel8able)

deriving stock instance f ~ Result => Show (Project f)

projectSchema :: TableSchema (Project Name)
projectSchema = TableSchema
  { name = "project"
  , schema = Nothing
  , columns = namesFromLabels @(Project Name)
  }

projectList :: Query (Project Expr)
projectList = each projectSchema

projectById :: Expr ProjectId -> Query (Project Expr)
projectById pid = filter (\p -> id p ==. pid) =<< each projectSchema

selectProjectById :: MonadIO m => Connection -> ProjectId -> m (Maybe (Project Result))
selectProjectById conn = liftIO . fmap listToMaybe . select conn . projectById . litExpr

insertProject :: MonadIO m => Connection -> Project Result -> m Int64
insertProject conn project = liftIO $ insert conn Insert
  { rows = [lit project]
  , onConflict = Abort
  , returning = NumberOfRowsAffected
  , into = projectSchema
  }

withConnection :: (Connection -> IO a) -> IO a
withConnection f = do
  let settings = C.settings "localhost" 5432 "checkit" "checkit" "checkit"
  Right conn <- C.acquire settings
  res <- f conn
  C.release conn
  pure res
