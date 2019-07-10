module Page.Package exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Component.Application.Package as Package
import Data.Resource exposing (Resource(..))
import Data.Application.Package exposing (Package)
import Data.Application.Standalone exposing (Standalone)
import Data.Config.Application exposing (Application)
import Data.Time exposing (Time)


view : Resource Application Package -> Time -> ( Maybe String, Html msg )
view application time =
  let
    title =
      case application of
        Fetching metadata -> metadata.name
        Failed metadata _ -> metadata.name
        Succeeded metadata _ -> metadata.name
  in
    ( Just title
    , div [ id "application" ] [ Package.full time application ]
    )
