module Data.Resource exposing (Resource(..), filter)


type Resource metadata resource
  = Fetching metadata
  | Failed metadata String
  | Succeeded metadata resource

filter : (resource -> Bool) -> Resource metadata resource -> Bool
filter filterFunction resource =
  case resource of
    Succeeded _ res -> filterFunction res
    _ -> True
