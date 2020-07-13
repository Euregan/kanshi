module Component.Logo exposing (display)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


display : Html msg
display =
  svg [ viewBox "0 0 100 100" ]
    [ Svg.path
      [ fill "transparent"
      , strokeLinejoin "round"
      , strokeLinecap "round"
      , d "M 2 50 L 20 50 L 35 10 L 60 90 L 75 50 L 98 50"
      ] []
    ]
