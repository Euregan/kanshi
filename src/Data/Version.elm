module Data.Version exposing (Version, fromString, incrementMajor, incrementMinor, incrementBugfix, decrementMajor, decrementMinor, decrementBugfix, dropMinor, dropBugfix, compare)


type alias Version = (Int, Int, Int)

fromString : String -> Maybe Version
fromString raw =
  case String.split "." raw of
    [stringMajor, stringMinor, stringBugfix] -> case (String.toInt stringMajor, String.toInt stringMinor, String.toInt stringBugfix) of
      (Just major, Just minor, Just bugfix) -> Just (major, minor, bugfix)
      _ -> Nothing
    _ -> Nothing

compare : Version -> Version -> Order
compare (majorA, minorA, bugfixA) (majorB, minorB, bugfixB) =
  if majorA > majorB then GT
  else if majorB > majorA then LT
  else if minorA > minorB then GT
  else if minorB > minorA then LT
  else if bugfixA > bugfixB then GT
  else if bugfixB > bugfixA then LT
  else EQ

incrementMajor : Version -> Version
incrementMajor (major, minor, bugfix) =
  (major + 1, minor, bugfix)

incrementMinor : Version -> Version
incrementMinor (major, minor, bugfix) =
  (major, minor + 1, bugfix)

incrementBugfix : Version -> Version
incrementBugfix (major, minor, bugfix) =
  (major, minor, bugfix + 1)

decrementMajor : Version -> Version
decrementMajor (major, minor, bugfix) =
  (major - 1, minor, bugfix)

decrementMinor : Version -> Version
decrementMinor (major, minor, bugfix) =
  (major, minor - 1, bugfix)

decrementBugfix : Version -> Version
decrementBugfix (major, minor, bugfix) =
  (major, minor, bugfix - 1)

dropMinor : Version -> Version
dropMinor (major, _, bugfix) =
  (major, 0, bugfix)

dropBugfix : Version -> Version
dropBugfix (major, minor, _) =
  (major, minor, 0)