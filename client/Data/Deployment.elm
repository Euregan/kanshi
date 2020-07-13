module Data.Deployment exposing (Deployment, decoder)

import Json.Decode as Decode exposing (field, int, string, nullable)
import Data.TaskStatus exposing (TaskStatus(..))
import Time exposing (Posix, millisToPosix)


type alias Deployment =
  { id : String
  , state : TaskStatus
  , date : Posix
  , url : Maybe String
  }

stateDecoder : Decode.Decoder TaskStatus
stateDecoder =
  string
    |> Decode.andThen (\str ->
      case str of
        "SUCCESS" -> Decode.succeed Succeeded
        "FAILED" -> Decode.succeed Failed
        "UNKNOWN" -> Decode.succeed Running
        somethingElse -> Decode.fail <| "État de build inconnu: " ++ somethingElse
    )

decoder : Decode.Decoder Deployment
decoder =
  Decode.map4 Deployment
    (field "id" <| Decode.oneOf [ string, int |> Decode.map (\int -> String.fromInt int) ])
    (field "state" stateDecoder)
    (field "date" (int |> Decode.map millisToPosix))
    (field "url" (nullable string))
