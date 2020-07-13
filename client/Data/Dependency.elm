module Data.Dependency exposing (Dependency, decoder, matches, fromString)

import Json.Decode as Decode exposing (Decoder)
import Data.Version as Version exposing (Version)


type alias Constraint =
  { minimum: Maybe Version
  , maximum: Maybe Version
  }

type alias Dependency =
  { raw: String
  , constraints: List Constraint
  }

matches : Dependency -> Version -> Bool
matches dependency version =
  case dependency.constraints of
    [] -> True
    _ -> List.foldr (\constraint acc -> acc || case (constraint.minimum, constraint.maximum) of
        (Just minimum, Just maximum) -> (Version.compare minimum version == LT || Version.compare minimum version == EQ) && Version.compare maximum version == GT
        (Just minimum, _) -> Version.compare minimum version == LT || Version.compare minimum version == EQ
        (_, Just maximum) -> Version.compare maximum version == GT
        _ -> True
      ) False dependency.constraints

decoder : Decoder Dependency
decoder =
  Decode.string |> Decode.map fromString


fromString : String -> Dependency
fromString raw =
  let
    toVersion rawDependency =
      case String.split "." rawDependency of
        [] -> Nothing
        [major] -> Version.fromString <| major ++ ".0.0"
        [major, minor] -> Version.fromString <| major ++ "." ++ minor ++ ".0"
        [major, minor, patch] -> Version.fromString <| major ++ "." ++ minor ++ "." ++ patch
        major::minor::patch::_ -> Version.fromString <| major ++ "." ++ minor ++ "." ++ patch
    increment rawDependency version =
      case String.split "." rawDependency of
        [] -> version
        [major] -> Version.incrementMajor version
        [major, minor] -> Version.incrementMinor version
        [major, minor, patch] -> Version.incrementPatch version
        major::minor::patch::_ -> Version.incrementPatch version
    decrement rawDependency version =
      case String.split "." rawDependency of
        [] -> version
        [major] -> Version.decrementMajor version
        [major, minor] -> Version.decrementMinor version
        [major, minor, patch] -> Version.decrementPatch version
        major::minor::patch::_ -> Version.decrementPatch version
  in
    case String.left 1 raw of
      "~" ->
        Dependency raw [ Constraint (String.dropLeft 1 raw |> Version.fromString) Nothing ]
      "^" ->
        Dependency raw [ Constraint (String.dropLeft 1 raw |> Version.fromString) (String.dropLeft 1 raw |> toVersion |> Maybe.map Version.incrementMajor |> Maybe.map Version.dropPatch |> Maybe.map Version.dropMinor) ]
      ">" ->
        Dependency raw [ Constraint (String.dropLeft 1 raw |> toVersion |> Maybe.map (increment <| String.dropLeft 1 raw)) Nothing ]
      "<" ->
        Dependency raw [ Constraint Nothing (String.dropLeft 1 raw |> toVersion |> Maybe.map (decrement <| String.dropLeft 1 raw)) ]
      _ -> case String.left 2 raw of
        ">=" ->
          Dependency raw [ Constraint (String.dropLeft 2 raw |> Version.fromString) Nothing ]
        "<=" ->
          Dependency raw [ Constraint Nothing (String.dropLeft 2 raw |> Version.fromString |> Maybe.map (increment raw)) ]
        "!=" ->
          Dependency raw []
        _ -> case String.right 1 raw of
          "*" ->
            Dependency raw [ Constraint Nothing Nothing ]
          _ ->
            Dependency raw [ Constraint (toVersion raw) (toVersion raw |> Maybe.map (increment raw)) ]
