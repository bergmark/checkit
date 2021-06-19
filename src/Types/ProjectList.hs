module Types.ProjectList where

import LocalPrelude

import Servant.API.UVerb

import Aeson
import Types.Project

data ProjectList = ProjectList
  { projects :: [Project]
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

instance HasStatus ProjectList where
  type StatusOf ProjectList = 200


emptyProjectList :: ProjectList
emptyProjectList = ProjectList { projects = [] }
