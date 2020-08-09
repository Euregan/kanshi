module Data.Profile.Asset exposing (Asset, decoder)

import Json.Decode as Decode exposing (Decoder, field, int, string, list)
import Data.Profile.Kind as Kind exposing (Kind)


type alias Asset =
  { name: String
  , size: Int
  , chunks: List String
  }

decoder : Decoder Asset
decoder =
  Decode.map3 Asset
    (field "name" string)
    (field "size" int)
    (field "chunks" <| list string)
