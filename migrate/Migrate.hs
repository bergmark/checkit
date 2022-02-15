module Main where

import Hasql.Migration
import Hasql.Transaction

import LocalPrelude

main :: IO ()
main = do
  migrations <- loadMigrationsFromDirectory "db-migrations"
  t <- pure $ runMigration MigrationInitialization
  ts <- forM migrations $ \migration ->
    _ $ runMigration MigrationValidation migration
  let queries = t : ts
  pure ()
