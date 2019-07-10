module Component.Deployment exposing (status, card)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Deployment exposing (Deployment)
import Component.Status as Status
import Component.Time as Time
import Data.Time exposing (Time)
import Data.TaskStatus exposing(TaskStatus(..))


status : Deployment -> Time -> Html msg
status deployment time =
  Status.inline
    ("Failed " ++ (Time.relative deployment.date time), [ title (Time.absolute time.zone deployment.date) ])
    ("Deployed " ++ (Time.relative deployment.date time), [ title (Time.absolute time.zone deployment.date) ])
    ("A deployment is running", [])
    deployment.state

card : List Deployment -> Time -> Html msg
card deployments time =
  let
    list =
      case deployments of
        [] ->
          div [ class "empty" ]
            [ div [ class "empty-icon" ] [ div [ class "icon icon-stop" ] [] ]
            , p [ class "empty-title" ] [ text "No deployment" ]
            ]
        nonEmptyDeployments -> div [ class "timeline" ] <| List.map (\deployment -> item deployment time) nonEmptyDeployments
  in
    div [ class "card" ]
      [ div [ class "card-header" ] [ h6 [ class "card-title" ]
        [ Maybe.withDefault (text "") (Maybe.map (\deployment -> Status.icon False deployment.state) (List.head deployments))
        , span [] [ text "Deployments" ]
        ] ]
      , div [ class "card-body" ] [ list ]
      ]

item : Deployment -> Time -> Html msg
item deployment time =
  let
    description =
      case deployment.state of
        Failed -> text "The deployment failed"
        Succeeded -> text "The deployment succeeded"
        Running -> text "The deployment is running"
    deploymentStatus =
      case deployment.url of
        Nothing -> span [] [ description ]
        Just url -> a [ href url, target "_blank" ] [ description ]
  in
    div [ class "timeline-item" ]
      [ div [ class "timeline-left" ] [ span [ class "timeline-icon icon-lg" ] [ Status.icon True deployment.state ] ]
      , div [ class "timeline-content" ]
        [ deploymentStatus
        , div [ class "text-gray", title (Time.absolute time.zone deployment.date) ] [ text (Time.relative deployment.date time) ]
        ]
      ]
