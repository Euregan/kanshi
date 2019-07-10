module Page.NotFound exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


view : ( Maybe String, Html msg )
view =
  ( Just "404"
  , h2 [] [ text "404 Not Found" ]
  )
