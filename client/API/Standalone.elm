module API.Standalone exposing (get)

import Http
import Url.Builder as Url exposing (string)
import Data.Config.Application exposing (Application)
import Data.Application.Standalone as Standalone exposing (Standalone)


get : Application -> (Result Http.Error Standalone -> msg) -> Cmd msg
get application msg =
  Http.get
    { url = "/api/standalone/" ++ application.id
    , expect = Http.expectJson msg Standalone.decoder
    }
