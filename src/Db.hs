module Db (FromDb (..), runQuery) where

import LocalPrelude hiding (filter, id)

import Hasql.Connection (Connection)
import Hasql.Connection qualified as C

class FromDb db a | db -> a, a -> db where
  fromDb :: db -> a

withConnection :: (Connection -> IO a) -> IO a
withConnection f = do
  let settings = C.settings "localhost" 5432 "checkit" "checkit" "checkit"
  Right conn <- C.acquire settings
  res <- f conn
  C.release conn
  pure res

runQuery :: MonadIO m => (Connection -> IO a) -> m a
runQuery = liftIO . Db.withConnection
