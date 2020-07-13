module Data.Version exposing (Version, decoder, fromString, toString, incrementMajor, incrementMinor, incrementPatch, decrementMajor, decrementMinor, decrementPatch, dropMinor, dropPatch, compare)

import Json.Decode as Decode exposing (Decoder)


type alias Version =
  { major: Int
  , minor: Int
  , patch: Int
  , modifier: Maybe String
  }

decoder : Decoder Version
decoder =
  let
    toDecoder : Maybe Version -> Decoder Version
    toDecoder maybeVersion =
      case maybeVersion of
        Just version -> Decode.succeed version
        Nothing -> Decode.fail "Version cannot be parsed"
  in
    Decode.string
      |> Decode.map fromString
      |> Decode.andThen toDecoder

fromString : String -> Maybe Version
fromString raw =
  let
    parsePatch rawPatch =
      case String.split "-" rawPatch of
        [patchVersion] -> String.toInt patchVersion |> Maybe.map (\patch -> (patch, Nothing))
        [patchVersion, modifier] -> String.toInt patchVersion |> Maybe.map (\patch -> (patch, Just modifier))
        _ -> Nothing
  in
    case String.split "." raw of
      [stringMajor, stringMinor, stringPatch] ->
        case (String.toInt stringMajor, String.toInt stringMinor, parsePatch stringPatch) of
          (Just major, Just minor, Just (patch, modifier)) -> Just {major = major, minor = minor, patch = patch, modifier = modifier}
          _ -> Nothing
      _ -> Nothing

toString : Version -> String
toString {major, minor, patch, modifier} =
  let
    modifierString =
      case modifier of
        Just actualModifier -> "-" ++ actualModifier
        Nothing -> ""
  in
    (String.join "." [String.fromInt major, String.fromInt minor, String.fromInt patch]) ++ modifierString

compare : Version -> Version -> Order
compare versionA versionB =
  if versionA.major > versionB.major then GT
  else if versionB.major > versionA.major then LT
  else if versionA.minor > versionB.minor then GT
  else if versionB.minor > versionA.minor then LT
  else if versionA.patch > versionB.patch then GT
  else if versionB.patch > versionA.patch then LT
  else EQ

incrementMajor : Version -> Version
incrementMajor version =
  { version | major = version.major + 1 }

incrementMinor : Version -> Version
incrementMinor version =
  { version | minor = version.minor +1 }

incrementPatch : Version -> Version
incrementPatch version =
  { version | patch = version.patch + 1 }

decrementMajor : Version -> Version
decrementMajor version =
  { version | major = version.major - 1 }

decrementMinor : Version -> Version
decrementMinor version =
  { version | minor = version.minor - 1 }

decrementPatch : Version -> Version
decrementPatch version =
  { version | patch = version.patch - 1 }

dropMinor : Version -> Version
dropMinor version =
  { version | minor = 0 }

dropPatch : Version -> Version
dropPatch version =
  { version | patch = 0 }
