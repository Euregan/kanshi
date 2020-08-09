module Data.Profile.Module exposing (Module, decoder)

import Json.Decode as Decode exposing (Decoder, field, int, string, list, lazy)
import Component.Graph.Sunburst exposing (Dial(..))
import Data.Profile.Kind as Kind exposing (Kind)


type alias Module = Dial
type Modules = Modules (List Module)

decoder : Decoder Module
decoder =
  Decode.map3 (\name size (Modules children) -> Dial {value = size, children = children, label = name})
    (field "name" string)
    (field "size" int)
    (field "children" decodeModules)

decodeModules : Decoder Modules
decodeModules =
  Decode.map Modules (list <| lazy (\_ -> decoder))
