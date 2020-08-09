module Data.Profile.Kind exposing (Kind, decoder)

import Json.Decode as Decode exposing (Decoder, string)


type Kind
  = JavaScript
  | CSS
  | Image
  | Font
  | Other String

decoder : Decoder Kind
decoder =
  string |> Decode.map (\kind -> case kind of
      "js" -> JavaScript
      "css" -> CSS
      "img" -> Image
      "font" -> Font
      _ -> Other kind
    )
