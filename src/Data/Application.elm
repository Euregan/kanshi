module Data.Application exposing (Application(..), decoder, name, id)

import Json.Decode as Decode exposing (field, string, list)
import Data.Application.Package as Package exposing (Package)
import Data.Application.Standalone as Standalone exposing (Standalone)


type Application
  = Package Package
  | Standalone Standalone

decoder : Decode.Decoder Application
decoder =
  (field "type" string) |> Decode.andThen (\str ->
    case str of
      "stand-alone" -> Standalone.decoder |> Decode.map (\application -> Standalone application)
      "package" -> Package.decoder |> Decode.map (\application -> Package application)
      somethingElse -> Decode.fail <| "Type d'application inconnu : " ++ somethingElse
  )

name : Application -> String
name application =
  case application of
    Standalone standalone -> standalone.name
    Package package -> package.name

id : Application -> String
id application =
  case application of
    Standalone standalone -> standalone.id
    Package package -> package.id
