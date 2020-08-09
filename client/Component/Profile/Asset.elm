module Component.Profile.Asset exposing (summary)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Profile.Asset exposing (Asset)
import Utility exposing (sizeToString)


summary : List Asset -> Html msg
summary assets =
  let
    count =
      List.length assets
    size =
      List.sum <| List.map (\asset -> asset.size) assets
  in
    div []
      [ text <| (String.fromInt count) ++ " asset" ++ (if count > 1 then "s" else "") ++ " with a size of " ++ (sizeToString size)
      ]
