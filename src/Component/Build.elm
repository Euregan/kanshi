module Component.Build exposing (status, card)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Build exposing (Build)
import Component.Status as Status
import Data.Time exposing (Time)


status : Build -> Time -> Html msg
status build time =
  Status.inline ("The last build failed", []) ("The last build succeeded", []) ("A build is running", []) build.state

card : List Build -> Time -> Html msg
card builds time =
  let
    list =
      case builds of
        [] ->
          div [ class "empty" ]
            [ div [ class "empty-icon" ] [ div [ class "icon icon-stop" ] [] ]
            , p [ class "empty-title" ] [ text "No build" ]
            ]
        nonEmptyBuilds -> ul [] <| List.map (\build -> li [] [ item build ]) nonEmptyBuilds
  in
    div [ class "card" ]
      [ div [ class "card-header" ] [ h6 [ class "card-title" ]
        [ Maybe.withDefault (text "") (Maybe.map (\build -> Status.icon False build.state) (List.head builds))
        , span [] [ text "Builds" ]
        ] ]
      , div [ class "card-body" ] [ list ]
      ]

item : Build -> Html msg
item build =
  let
    buildStatus =
      case build.url of
        Nothing -> span []
        Just url -> a [ href url, target "_blank" ]
    number = "#" ++ (String.fromInt build.number) ++ " "
  in
    a [ href (Maybe.withDefault "" build.url), target "_blank" ]
      [ Status.inline (number ++ "The build failed", []) (number ++ "The build succeeded", []) (number ++ "The build is running", []) build.state
      ]
