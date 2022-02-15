{-# OPTIONS -Wno-missing-exported-signatures #-}
{-# OPTIONS -Wno-missing-signatures #-}
module Client where

import Api
import Servant.API
import Servant.Client

(projectList :<|> projectCreate :<|> projectGet :<|> todoList :<|> todoCreate :<|> todoGet :<|> reportCreate :<|> reportGet) = client api
