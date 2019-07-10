module Component.Application exposing (item, full, summary, build, deployment)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Resource exposing (Resource(..))
import Data.Config.Application as Config
import Data.Build exposing (Build)
import Data.Deployment exposing (Deployment)
import Component.Build as Build
import Component.Deployment as Deployment
import Route exposing (Route)
import Data.Time exposing (Time)


item : Resource Config.Application application -> (application -> List (Html msg)) -> (String -> Route) -> Html msg
item application body route =
  let
    (title, content) =
      case application of
        Fetching metadata ->
          ( a [ Route.href <| route metadata.id ] [ text metadata.name ]
          , [ div [ class "loading loading-lg" ] [] ]
          )
        Failed metadata error ->
          ( a [ Route.href <| route metadata.id ] [ text metadata.name ]
          , [ li [ class "message bg-error" ] [ text error ] ]
          )
        Succeeded metadata app ->
          ( a [ Route.href <| route metadata.id ] [ text metadata.name ]
          , body app
          )
  in
    li [ class "card" ]
      [ div [ class "card-header" ]
        [ h5 [ class "card-title" ] [ title ]
        ]
      , ul [ class "card-body" ] content
      ]

emptyIcon : String -> Html msg
emptyIcon label =
  span []
    [ i [ class "icon icon-stop" ] []
    , span [] [ text label ]
    ]

build : Maybe Build -> Time -> Html msg
build maybeLastBuild time =
  case maybeLastBuild of
    Nothing -> emptyIcon "No build"
    Just lastBuild -> Build.status lastBuild time

deployment : Maybe Deployment -> Time -> Html msg
deployment maybeLastDeployment time =
  case maybeLastDeployment of
    Nothing -> emptyIcon "No deployment"
    Just lastBuild -> Deployment.status lastBuild time


full : Resource Config.Application application -> (application -> List (Html msg)) -> Html msg
full application body =
  let
    (title, content) =
      case application of
        Fetching metadata ->
          ( text metadata.name
          , [ div [ class "loading loading-lg" ] [] ]
          )
        Failed metadata error ->
          ( text metadata.name
          , [ span [ class "message bg-error" ] [ text error ] ]
          )
        Succeeded metadata app ->
          ( text metadata.name
          , body app
          )
  in
    div [ class "panel" ]
      [ div [ class "panel-header" ] [ h5 [ class "panel-title" ] [ title ]]
      , div [ class "panel-body container" ]
        [ div [ class "columns" ] content
        ]
      ]

summary : List (Html msg) -> Html msg
summary body =
  div [ class "card" ]
    [ div [ class "card-header" ]
      [ h6 [ class "card-title" ] [ text "Summary" ]
      ]
    , ul [ class "card-body" ] body
    ]
