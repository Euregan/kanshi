module Data.Time exposing (Time, yesterday, weekdayNumber)

import Time exposing (Posix, Zone, Weekday(..), here, now)


type alias Time =
  { now : Posix
  , zone : Zone
  }

yesterday : Weekday -> Weekday
yesterday day =
  case day of
    Mon -> Sun
    Tue -> Mon
    Wed -> Tue
    Thu -> Wed
    Fri -> Thu
    Sat -> Fri
    Sun -> Sat

weekdayNumber : Weekday -> Int
weekdayNumber day =
  case day of
    Mon -> 1
    Tue -> 2
    Wed -> 3
    Thu -> 4
    Fri -> 5
    Sat -> 6
    Sun -> 7
