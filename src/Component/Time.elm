module Component.Time exposing (relative, absolute, date)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time as Time exposing (Posix, Zone, utc, posixToMillis)
import Data.Time exposing (Time)


relative : Posix -> Time -> String
relative time now =
  let
    displayTime = posixToMillis time
    baseTime = posixToMillis now.now
  in
    if baseTime - displayTime < 60000 then -- Less than a minute
      (String.fromInt ((baseTime - displayTime) // 1000)) ++ " second" ++ (pluralize ((baseTime - displayTime) // 1000)) ++ " ago"
    else if baseTime - displayTime < 3600000 then -- Less than an hour
      (String.fromInt ((baseTime - displayTime) // 60000)) ++ " minute" ++ (pluralize ((baseTime - displayTime) // 60000)) ++ " ago"
    else if baseTime - displayTime < 86400000 then -- Less than a day
      (String.fromInt ((baseTime - displayTime) // 3600000)) ++ " hour" ++ (pluralize ((baseTime - displayTime) // 3600000)) ++ " ago"
    else if baseTime - displayTime < 604800000 then -- Less than a week
      (String.fromInt ((baseTime - displayTime) // 86400000)) ++ " day" ++ (pluralize ((baseTime - displayTime) // 86400000)) ++ " ago"
    else if baseTime - displayTime < 2592000000 then -- Less than a month
      (String.fromInt ((baseTime - displayTime) // 604800000)) ++ " week" ++ (pluralize ((baseTime - displayTime) // 604800000)) ++ " ago"
    else if baseTime - displayTime < 31536000000 then -- Less than a year
      (String.fromInt ((baseTime - displayTime) // 2592000000)) ++ " month" ++ " ago"
    else
      (String.fromInt ((baseTime - displayTime) // 31536000000)) ++ " year" ++ (pluralize ((baseTime - displayTime) // 31536000000)) ++ " ago"

absolute : Zone -> Posix -> String
absolute zone time =
  pad (Time.toDay zone time)
  ++ "/"
  ++ pad (toMonth zone time)
  ++ "/"
  ++ pad (Time.toYear zone time)
  ++ " at "
  ++ pad (Time.toHour zone time)
  ++ "h"
  ++ pad (Time.toMinute zone time)
  ++ ":"
  ++ pad (Time.toSecond zone time)

date : Zone -> Posix -> String
date zone time =
  pad (Time.toDay zone time)
  ++ "/"
  ++ pad (toMonth zone time)
  ++ "/"
  ++ pad (Time.toYear zone time)

pluralize : Int -> String
pluralize number =
  case number of
    1 -> ""
    _ -> "s"

toMonth : Zone -> Posix -> Int
toMonth zone time =
  case Time.toMonth zone time of
    Time.Jan -> 1
    Time.Feb -> 2
    Time.Mar -> 3
    Time.Apr -> 4
    Time.May -> 5
    Time.Jun -> 6
    Time.Jul -> 7
    Time.Aug -> 8
    Time.Sep -> 9
    Time.Oct -> 10
    Time.Nov -> 11
    Time.Dec -> 12

pad : Int -> String
pad number =
  if number < 10 then
    "0" ++ (String.fromInt number)
  else
    String.fromInt number
