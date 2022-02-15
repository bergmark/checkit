import LocalPrelude

import Client

main :: IO ()
main = do
  manager' <- newManager defaultManagerSettings
  res <- runClientM projectList (mkClientEnv manager' (BaseUrl Http "localhost" 8081 ""))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right books -> print books
