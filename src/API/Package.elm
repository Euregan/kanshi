module API.Package exposing (get)

import Http
import Data.Application.Package as Package exposing (Package)


get : String -> (Result Http.Error Package -> msg) -> Cmd msg
get package msg =
  Http.get
    { url = "/api/package/" ++ package
    , expect = Http.expectJson msg Package.decoder
    }
