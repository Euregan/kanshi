module Page exposing (Page(..), layout)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route)
import Data.Resource exposing (Resource)
import Data.Config.Application exposing (Application)
import Data.Application.Package exposing (Package)
import Data.Application.Standalone exposing (Standalone)


type Page
  = NotFound
  | Dashboard
  | Package String
  | Standalone String
  | Deployments

layout : Maybe String -> Html msg -> Browser.Document msg
layout title content =
  let
    headTitle =
      case title of
        Nothing -> "Kanshi"
        Just subtitle -> "Kanshi - " ++ subtitle
  in
    { title = headTitle
    , body =
      [ header [ class "navbar" ]
        [ section [ class "navbar-section" ]
          [ a [ class "navbar-brand text-bold mr-2", Route.href Route.Root ] [ text "Kanshi" ]
          , a [ Route.href Route.Deployments, class "btn btn-link" ] [ text "Deployments" ]
          ]
        ]
      , div [ id "content" ] [ content ]
      ]
    }
