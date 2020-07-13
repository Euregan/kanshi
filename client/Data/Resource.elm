module Data.Resource exposing (Resource(..))


type Resource metadata resource
  = Fetching metadata
  | Failed metadata String
  | Succeeded metadata resource
