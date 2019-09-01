module Component.Application.Package exposing (item, full)

import Html exposing (..)
import Html.Attributes exposing (..)
import Dict
import Data.Resource exposing (Resource(..))
import Data.Config.Application as Config
import Data.Application.Package exposing (Package)
import Data.Build exposing (Build)
import Data.Deployment exposing (Deployment)
import Component.Build as Build
import Component.Deployment as Deployment
import Component.Application as Application
import Component.Dependency as Dependency
import Route
import Data.Time exposing (Time)
import Data.Application as Application


item : Resource Config.Application Package -> Time -> List (Resource Config.Application Package) -> Html msg
item application time packages =
  Application.item
    application
    (summary time packages)
    Route.Package

summary : Time -> List (Resource Config.Application Package) -> Package -> List (Html msg)
summary time packages package =
  let
    filteredPackages =
      Application.packages (Maybe.withDefault Dict.empty package.packages) <|
        List.foldr (\resource acc -> case resource of
          Succeeded _ pack -> pack :: acc
          _ -> acc
        ) [] packages
  in
    [ li [] [ inline package ]
    , li [] [ Application.build (List.head package.builds) time ]
    , li [] [ Application.deployment (List.head package.deployments) time ]
    , li []
      (if List.isEmpty filteredPackages then
        []
      else
        [ h6 [] [ text "Packages" ]
        , ul [ class "package-packages" ] <| List.map (\(pack, ver, dependency) -> Dependency.item False pack ver dependency) filteredPackages
        ])
    ]

full : Time -> List (Resource Config.Application Package) -> Resource Config.Application Package -> Html msg
full time packages application =
  Application.full
    application
    (\package ->
      [ div [ class "column col-3" ] [ Application.summary (summary time packages package) ]
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
