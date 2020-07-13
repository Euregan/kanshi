module Data.Application.Standalone exposing (Standalone, decoder)

import Json.Decode as Decode exposing (Decoder, field, string, list, int, dict, nullable)
import Dict exposing (Dict)
import Data.Build as Build exposing (Build)
import Data.Deployment as Deployment exposing (Deployment)
import Data.Dependency as Dependency exposing (Dependency)
import Data.Version as Version exposing (Version)


type alias Standalone =
  { id: String
  , name : String
  , builds : List Build
  , deployments : List Deployment
  , calendar : List Int
  , packages : Dict String (Version, Dependency)
  }

decoder : Decoder Standalone
decoder =
  Decode.map6 Standalone
    (field "id" string)
    (field "name" string)
    (field "builds" (list Build.decoder))
    (field "deployments" (list Deployment.decoder))
    (field "calendar" (nullable (list int)) |> Decode.map (Maybe.withDefault []))
    (field "packages" (dict <| arrayAsTuple Version.decoder Dependency.decoder))

arrayAsTuple : Decoder a -> Decoder b -> Decoder (a, b)
arrayAsTuple a b =
  Decode.index 0 a
    |> Decode.andThen (\aVal -> Decode.index 1 b
    |> Decode.andThen (\bVal -> Decode.succeed (aVal, bVal)))
