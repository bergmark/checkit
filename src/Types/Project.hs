module Types.Project where

import LocalPrelude

import Servant.API.UVerb

import Aeson
import Types.ProjectFields

data Project = Project
  { id :: ProjectId
  , name :: ProjectName
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

instance HasStatus Project where
  type StatusOf Project = 200
