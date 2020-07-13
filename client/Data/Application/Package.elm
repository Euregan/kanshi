module Data.Application.Package exposing (Package, decoder)

import Json.Decode as Decode exposing (Decoder, field, string, list, dict, nullable)
import Dict exposing (Dict)
import Data.Build as Build exposing (Build)
import Data.Deployment as Deployment exposing (Deployment)
import Data.Dependency as Dependency exposing (Dependency)
import Data.Version as Version exposing (Version)


type alias Package =
  { id: String
  , publicationName : String
  , name : String
  , versions : List String
  , builds : List Build
  , deployments : List Deployment
  , packages : Maybe (Dict String (Version, Dependency))
  }

decoder : Decoder Package
decoder =
  Decode.map7 Package
    (field "id" string)
    (field "publicationName" (nullable string |> Decode.map (Maybe.withDefault "")))
    (field "name" string)
    (field "versions" (list string))
    (field "builds" (list Build.decoder))
    (field "deployments" (list Deployment.decoder))
    (Decode.maybe (field "packages" (dict <| arrayAsTuple Version.decoder Dependency.decoder)))

arrayAsTuple : Decoder a -> Decoder b -> Decoder (a, b)
arrayAsTuple a b =
  Decode.index 0 a
    |> Decode.andThen (\aVal -> Decode.index 1 b
    |> Decode.andThen (\bVal -> Decode.succeed (aVal, bVal)))
