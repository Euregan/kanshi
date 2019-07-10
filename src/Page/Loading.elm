module Page.Loading exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


view : ( Maybe String, Html msg )
view =
  ( Nothing
  , div [ class "loading loading-lg" ] []
  )
