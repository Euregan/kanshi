module Data.Application.Package exposing (Package, decoder)

import Json.Decode as Decode exposing (field, string, list, nullable)
import Data.Build as Build exposing (Build)
import Data.Deployment as Deployment exposing (Deployment)


type alias Package =
  { id: String
  , publicationName : String
  , name : String
  , versions : List String
  , builds : List Build
  , deployments : List Deployment
  }

decoder : Decode.Decoder Package
decoder =
  Decode.map6 Package
    (field "id" string)
    (field "publicationName" (nullable string |> Decode.map (Maybe.withDefault "")))
    (field "name" string)
    (field "versions" (list string))
    (field "builds" (list Build.decoder))
    (field "deployments" (list Deployment.decoder))
