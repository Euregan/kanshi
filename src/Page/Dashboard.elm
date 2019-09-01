module Page.Dashboard exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Resource exposing (Resource)
import Data.Application.Package exposing (Package)
import Data.Application.Standalone exposing (Standalone)
import Data.Config.Application exposing (Application)
import Component.Application.Package as Package
import Component.Application.Standalone as Standalone
import Data.Time exposing (Time)


view : List (Resource Application Package) -> List (Resource Application Standalone) -> Time -> ( Maybe String, Html msg )
view packages standalones time =
  ( Nothing
  , div [ id "dashboard" ]
    [ h4 [] [ text "Standalones" ]
    , div [ class "applications" ] <| List.map (\application -> Standalone.item application time packages) standalones
    , h4 [] [ text "Packages"]
    , div [ class "applications" ] <| List.map (\application -> Package.item application time packages) packages
    ]
  )
