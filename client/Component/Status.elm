module Component.Status exposing (inline, icon)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.TaskStatus exposing(TaskStatus(..))
import Component.Logo as Logo


inline : (String, List (Attribute msg)) -> (String, List (Attribute msg)) -> (String, List (Attribute msg)) -> (String, List (Attribute msg)) -> TaskStatus-> Html msg
inline (failureText, failureAttributes) (successText, successAttributes) (cancelText, cancelAttributes) (runText, runAttributes) status =
  case status of
    Failed ->
      span [ class "build-status" ]
        [ icon False status
        , span failureAttributes [ text failureText ]
        ]
    Succeeded ->
      span [ class "build-status" ]
        [ icon False status
        , span successAttributes [ text successText ]
        ]
    Canceled ->
      span [ class "build-status" ]
        [ icon False status
        , span cancelAttributes [ text cancelText ]
        ]
    Running ->
      span [ class "build-status" ]
        [ icon False status
        , span runAttributes [ text runText ]
        ]

icon : Bool -> TaskStatus -> Html msg
icon full status =
  case (full, status) of
    (True, Failed) -> i [ class "bg-error icon icon-cross" ] []
    (False, Failed) -> i [ class "text-error icon icon-cross" ] []
    (True, Succeeded) -> i [ class "bg-success icon icon-check" ] []
    (False, Succeeded) -> i [ class "text-success icon icon-check" ] []
    (_, Canceled) -> i [ class "icon icon-cross" ] []
    (_, Running) -> i [ class "icon icon-building" ] [ Logo.display ]
