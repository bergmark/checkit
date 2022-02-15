{-# LANGUAGE UndecidableInstances #-}
module Types.Error where

import LocalPrelude

data ProjectNotFound = ProjectNotFound
  deriving stock Generic
  deriving HasStatus via WithStatus 404 ProjectNotFound
  deriving anyclass (ToJSON, FromJSON)

data TodoNotFound = TodoNotFound
  deriving stock Generic
  deriving HasStatus via WithStatus 404 TodoNotFound
  deriving anyclass (ToJSON, FromJSON)

data ReportNotFound = ReportNotFound
  deriving stock Generic
  deriving HasStatus via WithStatus 404 ReportNotFound
  deriving anyclass (ToJSON, FromJSON)
