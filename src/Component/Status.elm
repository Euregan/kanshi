module Component.Status exposing (inline, icon)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.TaskStatus exposing(TaskStatus(..))


inline : (String, List (Attribute msg)) -> (String, List (Attribute msg)) -> (String, List (Attribute msg)) -> TaskStatus-> Html msg
inline (failureText, failureAttributes) (successText, successAttributes) (runText, runAttributes) status =
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
    Running ->
      span [ class "build-status" ]
        [ icon False status
        , span runAttributes [ text runText ]
        ]

icon : Bool -> TaskStatus -> Html msg
icon full status =
  let
    iconClass =
      case status of
        Failed -> "icon-cross"
        Succeeded -> "icon-check"
        Running -> "loading"
    colorClass =
      case (full, status) of
        (True, Failed) -> "bg-error"
        (False, Failed) -> "text-error"
        (True, Succeeded) -> "bg-success"
        (False, Succeeded) -> "text-success"
        (_, Running) -> ""
  in
    i [ class <| colorClass ++ " icon " ++ iconClass ] []
