module Component.Application.Standalone exposing (item, full, deployments)

import Html exposing (..)
import Html.Attributes exposing (..)
import Dict
import Data.Resource exposing (Resource(..))
import Data.Config.Application as Config
import Data.Application.Standalone exposing (Standalone)
import Data.Application.Package exposing (Package)
import Data.Build exposing (Build)
import Data.Deployment exposing (Deployment)
import Component.Build as Build
import Component.Deployment as Deployment
import Component.Application as Application
import Component.Time as Time
import Component.Dependency as Dependency
import Route
import Data.Time exposing (Time, yesterday, weekdayNumber)
import Time exposing (Posix, posixToMillis, millisToPosix)
import Data.Dependency as Dependency exposing (Dependency)
import Data.Version as Version exposing (Version)
import Data.Application as Application


item : Resource Config.Application Standalone -> Time -> List (Resource Config.Application Package) -> Html msg
item application time packages =
  Application.item
    application
    (summary time packages)
    Route.Standalone

summary : Time -> List (Resource Config.Application Package) -> Standalone -> List (Html msg)
summary time packages standalone =
  let
    filteredPackages =
      Application.packages standalone.packages <|
        List.foldr (\resource acc -> case resource of
          Succeeded _ package -> package :: acc
          _ -> acc
        ) [] packages
  in
    [ li [] [ Application.build (List.head standalone.builds) time ]
    , li [] [ Application.deployment (List.head standalone.deployments) time ]
    , li []
      (if List.isEmpty filteredPackages then
        []
      else
        [ h6 [] [ text "Packages" ]
        , ul [ class "standalone-packages" ] <| List.map (\(package, version, dependency) -> Dependency.item False package version dependency) filteredPackages
        ])
    ]

full : Time -> List (Resource Config.Application Package) -> Resource Config.Application Standalone -> Html msg
full time packages application =
  Application.full
    application
    (\standalone ->
      [ div [ class "column col-4" ] [ Application.summary <| List.concat [summary time packages standalone, [timeline time standalone]] ]
      , div [ class "column col-4" ] [ Build.card standalone.builds time ]
      , div [ class "column col-4" ] [ Deployment.card standalone.deployments time ]
      ]
    )

deployments : Time -> Resource Config.Application Standalone -> Html msg
deployments time application =
  let
    (title, content) =
      case application of
        Fetching metadata ->
          ( a [ Route.href <| Route.Standalone metadata.id ] [ text metadata.name ]
          , [ div [ class "loading loading-lg" ] [] ]
          )
        Failed metadata error ->
          ( a [ Route.href <| Route.Standalone metadata.id ] [ text metadata.name ]
          , [ text error ]
          )
        Succeeded metadata app ->
          ( a [ Route.href <| Route.Standalone metadata.id ] [ text metadata.name ]
          , [ timeline time app ]
          )
  in
    div [ class "card" ]
      [ div [ class "card-header" ]
        [ h5 [ class "card-title" ] [ title ]
        ]
      , ul [ class "card-body" ] content
      ]

timeline : Time -> Standalone -> Html msg
timeline time application =
  let
    startDay =
      Time.toWeekday time.zone time.now
        |> weekdayNumber
    zeroToSeven num =
      if num == 0 then
        7
      else
        num
    countToTitle days count =
      let
        countText =
          case count of
            0 -> "No deployment"
            1 -> "1 deployment"
            x -> (String.fromInt count) ++ " deployments"
        date =
          (posixToMillis time.now) - (364 - days) * 24 * 3600 * 1000 |>
          millisToPosix |>
            Time.date time.zone
      in
        date ++ "\n" ++ countText
  in
    List.concat
      [ List.repeat startDay Nothing
      , List.map (\count -> Just count) application.calendar
      , List.repeat (7 - startDay) Nothing
      ] |>
    List.indexedMap (\index count -> (index, count)) |>
    List.sortWith (\(dayA, _) (dayB, _) -> compare (zeroToSeven (modBy 7 (dayA + 1))) (zeroToSeven (modBy 7 (dayB + 1)))) |>
    List.map (\(day, maybeCount) ->
      case maybeCount of
        Nothing -> div [ class <| "day empty day-" ++ (String.fromInt day) ] []
        Just count -> div [ class <| "day count-" ++ (String.fromInt count) ++ " day-" ++ (String.fromInt day), title (countToTitle day count) ] []) |>
    div [ class "calendar" ]
