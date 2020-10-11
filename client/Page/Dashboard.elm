module Page.Dashboard exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Data.Resource as Resource exposing (Resource)
import Data.Application.Package exposing (Package)
import Data.Application.Standalone exposing (Standalone)
import Data.Config.Application exposing (Application)
import Component.Application.Package as Package
import Component.Application.Standalone as Standalone
import Data.Time exposing (Time)

view : List (String, Bool) -> List (Resource Application Package) -> List (Resource Application Standalone) -> Time -> (String -> msg) -> ( Maybe String, Html msg )
view tags packages standalones time toggleTag =
  let
    enabledTags : List String
    enabledTags =
      List.map (\(tag, _) -> tag) <| List.filter (\(tag, enabled) -> enabled) tags

    filter : List (Resource Application { r | tags : List String }) -> List (Resource Application { r | tags : List String })
    filter resources =
       List.filter (Resource.filter (\app -> List.any (\tag -> List.any (\appTag -> appTag == tag) app.tags) enabledTags)) resources
  in
    ( Nothing
    , div [ id "dashboard" ]
      [ div [ class "filters"]
        [ div [ class "action" ] [ text "Filters" ]
        , div [ class "filters-hidden" ]
          [ div [ class "card" ]
            [ div [ class "card-body" ] <| List.map (\(label, enabled) ->
                span [ class <| "chip" ++ if enabled then " bg-primary" else "", onClick (toggleTag label) ] [ text label ]
              ) tags
            ]
          ]
        ]
      , h4 [] [ text "Standalones" ]
      , div [ class "applications" ] <| List.map (\application -> Standalone.item application time packages) <| filter <| standalones
      , h4 [] [ text "Packages"]
      , div [ class "applications" ] <| List.map (\application -> Package.item application time packages) <| filter <| packages
      ]
    )
