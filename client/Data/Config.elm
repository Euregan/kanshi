module Data.Config exposing (Config)

import Data.Config.Application exposing (Application)


type alias Config =
  { packages : List Application
  , standalones : List Application
  }
