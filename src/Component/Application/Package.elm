module Component.Application.Package exposing (item, full)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Resource exposing (Resource)
import Data.Config.Application as Config
import Data.Application.Package exposing (Package)
import Data.Build exposing (Build)
import Data.Deployment exposing (Deployment)
import Component.Build as Build
import Component.Deployment as Deployment
import Component.Application as Application
import Route
import Data.Time exposing (Time)


item : Resource Config.Application Package -> Time -> Html msg
item application time =
  Application.item
    application
    (summary time)
    Route.Package

summary : Time -> Package -> List (Html msg)
summary time package =
  [ li [] [ inline package ]
  , li [] [ Application.build (List.head package.builds) time ]
  , li [] [ Application.deployment (List.head package.deployments) time ]
  ]

full : Time -> Resource Config.Application Package -> Html msg
full time application =
  Application.full
    application
    (\package ->
      [ div [ class "column col-3" ] [ Application.summary (summary time package) ]
      , div [ class "column col-3" ] [ card package ]
      , div [ class "column col-3" ] [ Build.card package.builds time ]
      , div [ class "column col-3" ] [ Deployment.card package.deployments time ]
      ]
    )

inline : Package -> Html msg
inline package =
  span [ class "package inline" ]
    [ span [] [ text package.publicationName ]
    , span [ class "text-gray" ] [ text <| Maybe.withDefault "" (List.head package.versions) ]
    ]

card : Package -> Html msg
card package =
  div [ class "card" ]
    [ div [ class "card-header" ] [ h6 [ class "card-title" ]
      [ span [] [ text "Versions" ]
      ] ]
    , div [ class "card-body" ]
      [ div []
        [ text package.publicationName
        , ul [] <| List.map (\ver -> li [] [ version ver ]) package.versions
        ]
      ]
    ]

version : String -> Html msg
version ver =
  span [] [ text ver ]
