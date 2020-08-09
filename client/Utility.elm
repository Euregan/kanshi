module Utility exposing (sizeToString, timeToString)


round : Int -> Float -> Float
round precision number =
  (toFloat <| Basics.round <| number * (10 ^ toFloat precision)) / (10 ^ toFloat precision)

sizeToString : Int -> String
sizeToString size =
  let
    stringify : Float -> String
    stringify divider =
      (String.fromFloat <| round 2 <| toFloat size / divider)
  in
    if size < 1000 then
      (String.fromInt size) ++ "B"
    else if size < 1000000 then
      (stringify 1000) ++ "KB"
    else if size < 1000000000 then
      (stringify 1000000) ++ "MB"
    else
      (stringify 1000000000) ++ "GB"

timeToString : Int -> String
timeToString time =
  if time < 1000 then
    (String.fromInt time) ++ "ms"
  else if time < 1000 * 60 then
    (String.fromFloat <| round 2 <| toFloat time / 1000) ++ "s"
  else if time < 1000 * 60 * 60 then
    (String.fromFloat <| round 2 <| toFloat time / (1000 * 60)) ++ "min"
  else
    (String.fromFloat <| round 2 <| toFloat time / (1000 * 60 * 60)) ++ "h"
