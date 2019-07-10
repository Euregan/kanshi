module Data.Application.Standalone exposing (Standalone, decoder)

import Json.Decode as Decode exposing (field, string, list, int, dict)
import Dict exposing (Dict)
import Data.Build as Build exposing (Build)
import Data.Deployment as Deployment exposing (Deployment)


type alias Standalone =
  { id: String
  , name : String
  , builds : List Build
  , deployments : List Deployment
  , calendar : List Int
  , packages : Dict String String
  }

decoder : Decode.Decoder Standalone
decoder =
  Decode.map6 Standalone
    (field "id" string)
    (field "name" string)
    (field "builds" (list Build.decoder))
    (field "deployments" (list Deployment.decoder))
    (field "calendar" (list int))
    (field "packages" (dict string))
