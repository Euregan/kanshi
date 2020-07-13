module Page.Deployments exposing (view)

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


view : List (Resource Application Standalone) -> Time -> ( Maybe String, Html msg )
view standalones time =
  ( Just "Deployments"
  , div [ id "deployments" ] <|
    List.map (Standalone.deployments time) standalones
  )
