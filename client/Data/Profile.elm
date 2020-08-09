module Data.Profile exposing (Profile, decoder)

import Json.Decode as Decode exposing (Decoder, field, list, int)
import Data.Profile.Asset as Asset exposing (Asset)
import Data.Profile.Module as Module exposing (Module)


type alias Profile =
  { assets: List Asset
  , modules: List Module
  , time: Int
  }

decoder : Decoder Profile
decoder =
  Decode.map3 Profile
    (field "assets" <| list Asset.decoder)
    (field "modules" <| list Module.decoder)
    (field "time" int)
