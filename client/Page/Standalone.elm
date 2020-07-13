module Page.Standalone exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Component.Application.Standalone as Standalone
import Data.Resource exposing (Resource(..))
import Data.Application.Package exposing (Package)
import Data.Application.Standalone exposing (Standalone)
import Data.Config.Application exposing (Application)
import Data.Time exposing (Time)


view : Resource Application Standalone -> Time -> List (Resource Application Package) -> ( Maybe String, Html msg )
view application time packages =
  let
    title =
      case application of
        Fetching metadata -> metadata.name
        Failed metadata _ -> metadata.name
        Succeeded metadata _ -> metadata.name
  in
    ( Just title
    , div [ id "application" ] [ Standalone.full time packages application ]
    )
