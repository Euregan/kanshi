module Component.Dependency exposing (item)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Dependency as Dependency exposing (Dependency)
import Data.Version as Version exposing (Version)


item : Bool -> String -> Version -> (Version, Dependency) -> Html msg
item detailed package latest (installed, dependency) =
  let
    dependencyMatches =
      Dependency.matches dependency latest
    installedMatches =
      Version.compare latest installed == EQ
    colorClass =
      case (dependencyMatches, installedMatches) of
        (False, _) -> "text-error"
        (True, False) -> "text-warning"
        (True, True) -> "text-gray"
  in
    case detailed of
      False ->
        li [ title <| "Locked version: " ++ (Version.toString installed) ]
          [ span [] [ text package ]
          , span [ class colorClass ] [ text dependency.raw ]
          ]
      True ->
        li []
          [ span [] [ text package ]
          , ul []
            [ li [] [ span [] [ text "Dependency" ], span [] [ text dependency.raw ] ]
            , li [] [ span [] [ text "Locked version" ], span [] [ text <| Version.toString installed ] ]
            ]
          ]
