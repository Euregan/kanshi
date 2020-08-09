module Data.Build exposing (Build, decoder)

import Json.Decode as Decode exposing (field, string, int, nullable, dict, maybe)
import Dict exposing (Dict)
import Data.TaskStatus exposing (TaskStatus(..))
import Data.Profile as Profile exposing (Profile)


type alias Build =
  { id : String
  , state : TaskStatus
  , number : Int
  , url : Maybe String
  , profiles: Maybe (Dict String Profile)
  }

stateDecoder : Decode.Decoder TaskStatus
stateDecoder =
  string
    |> Decode.andThen (\str ->
      case str of
        "Successful" -> Decode.succeed Succeeded
        "Failed" -> Decode.succeed Failed
        "InProgress" -> Decode.succeed Running
        "Canceled" -> Decode.succeed Canceled
        somethingElse -> Decode.fail <| "Unkown build state: " ++ somethingElse
    )

decoder : Decode.Decoder Build
decoder =
  Decode.map5 Build
    (field "id" string)
    (field "state" stateDecoder)
    (field "number" int)
    (field "url" (nullable string))
    (maybe <| field "profiles" (dict Profile.decoder))
