module Page.Error exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> ( Maybe String, Html msg )
view error =
  ( Just "Error"
  , h2 [] [ text error ]
  )
