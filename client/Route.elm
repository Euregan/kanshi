module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


-- ROUTING

type Route
  = Root
  | Package String
  | Standalone String
  | Deployments
  -- | PackageProfile String String
  -- | StandaloneProfile String String

parser : Parser (Route -> a) a
parser =
  oneOf
    [ Parser.map Root Parser.top
    , Parser.map Package (s "package" </> string)
    , Parser.map Standalone (s "standalone" </> string)
    -- , Parser.map PackageProfile (s "package" </> string </> s "profile" </> string)
    -- , Parser.map StandaloneProfile (s "standalone" </> string </> s "profile" </> string)
    , Parser.map Deployments (s "deployments")
    ]

-- PUBLIC HELPERS

href : Route -> Attribute msg
href targetRoute =
  Attr.href (routeToString targetRoute)

replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
  Nav.replaceUrl key (routeToString route)

fromUrl : Url -> Maybe Route
fromUrl =
  Parser.parse parser

-- INTERNAL

routeToString : Route -> String
routeToString page =
  let
    pieces =
      case page of
        Root -> []
        Package name -> [ "package", name ]
        Standalone name -> [ "standalone", name ]
        -- PackageProfile name profile -> [ "package", name, "profile", profile]
        -- StandaloneProfile name profile -> [ "standalone", name, "profile", profile ]
        Deployments -> [ "deployments" ]
    in
      "/" ++ String.join "/" pieces
