module Types.ProjectFields where

import LocalPrelude

import System.Random
import Data.UUID.Types
import Rel8
import Servant.API (FromHttpApiData, ToHttpApiData)

import Aeson
import ParamName

newtype ProjectId = ProjectId { unProjectId :: UUID }
  deriving stock (Eq, Show, Generic)
  deriving (Hashable, ToJSON, FromJSON, FromHttpApiData, ToHttpApiData, DBEq, DBType) via UUID

newProjectId :: MonadIO m => m ProjectId
newProjectId = ProjectId <$> liftIO randomIO

instance ParamName ProjectId  where
  type ParamSym ProjectId = "projectId"

newtype ProjectName = ProjectName { unProjectName :: Text }
  deriving stock (Eq, Show, Generic)
  deriving (ToJSON, FromJSON, DBEq, DBType) via Text
