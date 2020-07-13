module Data.Application exposing (packages)

import Dict exposing (Dict)
import Data.Resource exposing (Resource(..))
import Data.Application.Package exposing (Package)
import Data.Config.Application as Config
import Data.Version as Version exposing (Version)
import Data.Dependency as Dependency exposing (Dependency)


packages : Dict String (Version, Dependency) -> List Package -> List (String, Version, (Version, Dependency))
packages dependencies existing =
  let
    findPackage name =
        List.filter (\package -> package.publicationName == name) existing |>
        List.head
  in
    Dict.toList dependencies |>
      List.foldl (\(package, dependency) acc ->
        case findPackage package
          |> Maybe.andThen (\pack -> List.head pack.versions)
          |> Maybe.andThen Version.fromString of
          Nothing -> acc
          Just version -> (package, version, dependency) :: acc
        ) []
