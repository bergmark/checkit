module Types.ReportFields where

import LocalPrelude

newtype ReportId = ReportId { unReportId :: UUID }
  deriving stock (Eq, Show, Generic)
  deriving (Hashable, ToJSON, FromJSON, FromHttpApiData, ToHttpApiData, DBEq, DBType) via UUID

instance ParamName ReportId where
  type ParamSym ReportId = "reportId"

newReportId :: MonadIO m => m ReportId
newReportId = ReportId <$> liftIO randomIO
