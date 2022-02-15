{-# LANGUAGE UndecidableInstances #-}
module Types.Project where

import LocalPrelude

import Types.ProjectFields

data Project = Project
  { projectId :: ProjectId
  , name :: ProjectName
  } deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)
    deriving HasStatus via WithStatus 200 Project
