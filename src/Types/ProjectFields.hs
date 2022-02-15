module Types.ProjectFields where

import LocalPrelude

newtype ProjectId = ProjectId { unProjectId :: UUID }
  deriving stock (Eq, Show, Generic)
  deriving (Hashable, ToJSON, FromJSON, FromHttpApiData, ToHttpApiData, DBEq, DBType) via UUID

instance ParamName ProjectId where
  type ParamSym ProjectId = "projectId"

newProjectId :: MonadIO m => m ProjectId
newProjectId = ProjectId <$> liftIO randomIO

newtype ProjectName = ProjectName { unProjectName :: Text }
  deriving stock (Eq, Show, Generic)
  deriving (ToJSON, FromJSON, DBEq, DBType) via Text
