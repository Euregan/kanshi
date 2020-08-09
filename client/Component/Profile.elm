module Component.Profile exposing (card)

import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (Dict)
import Data.Profile exposing (Profile)
import Component.Profile.Asset as Asset
import Component.Graph.Sunburst as Sunburst
import Utility exposing (timeToString)


card : Dict String Profile -> Html msg
card profiles =
  div [ class "card" ]
    [ div [ class "card-header" ]
      [ h6 [ class "card-title" ] [ text "Profiles" ]
      ]
    , div [ class "card-body" ]
      ( Dict.toList profiles
        |> List.map (\(title, profile) ->
            div []
              [ div [ class "divider text-center", attribute "data-content" title ] []
              , div []
                [ div [] [ text <| "Took " ++ (timeToString profile.time) ]
                , Asset.summary profile.assets
                , Sunburst.graph profile.modules
                ]
              ]
          )
      )
    ]
