module Types.CreateProject where

import LocalPrelude

import Types.ProjectFields

data CreateProject = CreateProject
  { name :: ProjectName
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)
