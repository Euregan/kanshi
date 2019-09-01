port module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Url
import Url.Parser as Parser exposing (Parser, (</>), custom, fragment, map, oneOf, s, top)
import Http
import Html exposing (..)
import Time exposing (Posix, Zone, utc, here, now, millisToPosix, every)
import Task
import Dict exposing (Dict)
import Data.Resource exposing (Resource(..))
import API.Package as Package
import API.Standalone as Standalone
import Data.Config as Config exposing (Config)
import Data.Config.Application as Config
import Data.Application.Package exposing (Package)
import Data.Application.Standalone exposing (Standalone)
import Page.Dashboard as Dashboard
import Page.Package as Package
import Page.Standalone as Standalone
import Page.NotFound as NotFound
import Page.Error as Error
import Page.Loading as Loading
import Page.Deployments as Deployments
import Page exposing (Page)
import Route exposing (Route)
import Data.Time exposing (Time)


type alias Model =
  { key : Navigation.Key
  , time : Time
  , page : Page
  , packages : Dict String (Resource Config.Application Package)
  , standalones : Dict String (Resource Config.Application Standalone)
  , config : Config
  , pendingConfig : Config
  }

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | TimeUpdated Posix
  | ZoneUpdated Zone
  | GotPackage Config.Application (Result Http.Error Package)
  | GotStandalone Config.Application (Result Http.Error Standalone)
  | ApplyPendingConfig
  | CancelPendingConfig
  | UpdateAll Posix

main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.batch [ every 1000 TimeUpdated, every 60000 UpdateAll ]
    , onUrlRequest = LinkClicked
    , onUrlChange = UrlChanged
    }

view : Model -> Browser.Document Msg
view model =
  let
    (title, content) =
      case model.page of
        Page.NotFound -> NotFound.view
        Page.Dashboard -> Dashboard.view (Dict.values model.packages) (Dict.values model.standalones) model.time
        Page.Package id ->
          case Dict.get id model.packages of
            Nothing -> NotFound.view
            Just package -> Package.view package model.time (Dict.values model.packages)
        Page.Standalone id ->
          case Dict.get id model.standalones of
            Nothing -> NotFound.view
            Just standalone -> Standalone.view standalone model.time (Dict.values model.packages)
        Page.Deployments ->
          Deployments.view (Dict.values model.standalones) model.time
  in
    Page.layout title content

init : {config: Config} -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init {config} url key =
  let
    packages = pendPackages config.packages
    standalones = pendStandalones config.standalones
  in
    ( { key = key
      , time =
        { now = millisToPosix 0
        , zone = utc
        }
      , page = routeToPage (Route.fromUrl url) packages standalones
      , packages = packages
      , standalones = standalones
      , config = config
      , pendingConfig = config
      }
    , Cmd.batch <| List.concat
      [ [ Task.perform TimeUpdated now, Task.perform ZoneUpdated here ]
      , fetchPackages config.packages
      , fetchStandalones config.standalones
      ]
    )

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model
          , Navigation.pushUrl model.key (Url.toString url)
          )
        Browser.External href ->
          ( model
          , Navigation.load href
          )
    UrlChanged url ->
      ( { model | page = routeToPage (Route.fromUrl url) model.packages model.standalones }
      , Cmd.none
      )
    ZoneUpdated zone ->
      ( { model | time = { now = model.time.now, zone = zone } }
      , Cmd.none
      )
    TimeUpdated time ->
      ( { model | time = { now = time, zone = model.time.zone } }
      , Cmd.none
      )
    GotPackage application (Ok package) ->
      ( { model | packages = Dict.insert application.id (Succeeded application package) model.packages }
      , Cmd.none
      )
    GotPackage application (Err error) ->
      ( { model | packages = Dict.insert application.id (Failed application (errorToMessage error)) model.packages }
      , Cmd.none
      )
    GotStandalone application (Ok standalone) ->
      ( { model | standalones = Dict.insert application.id (Succeeded application standalone) model.standalones }
      , Cmd.none
      )
    GotStandalone application (Err error) ->
      ( { model | standalones = Dict.insert application.id (Failed application (errorToMessage error)) model.standalones }
      , Cmd.none
      )
    ApplyPendingConfig ->
      ( { model | config = model.pendingConfig, standalones = pendStandalones model.pendingConfig.standalones, packages = pendPackages model.pendingConfig.packages }
      , Cmd.batch <| List.concat
        [ [ updateConfig model.pendingConfig ]
        , fetchStandalones model.pendingConfig.standalones
        , fetchPackages model.pendingConfig.packages
        ]
      )
    CancelPendingConfig ->
      ( { model | pendingConfig = model.config }
      , Cmd.none
      )
    UpdateAll _ ->
      ( model
      , Cmd.batch <| List.concat
        [ fetchPackages model.config.packages
        , fetchStandalones model.config.standalones
        ]
      )

pendStandalones : List Config.Application -> Dict String (Resource Config.Application Standalone)
pendStandalones standalones =
  Dict.fromList <| List.map (\standalone -> (standalone.id, Fetching standalone)) standalones

pendPackages : List Config.Application -> Dict String (Resource Config.Application Package)
pendPackages packages =
  Dict.fromList <| List.map (\package -> (package.id, Fetching package)) packages

fetchStandalones : List Config.Application -> List (Cmd Msg)
fetchStandalones standalones =
  List.map (\standalone -> Standalone.get standalone (GotStandalone standalone)) standalones

fetchPackages : List Config.Application -> List (Cmd Msg)
fetchPackages packages =
  List.map (\package -> Package.get package.id (GotPackage package)) packages

routeToPage : Maybe Route -> Dict String (Resource Config.Application Package) -> Dict String (Resource Config.Application Standalone) -> Page
routeToPage route packages standalones =
  case route of
    Nothing ->
      Page.NotFound
    Just Route.Root ->
      Page.Dashboard
    Just (Route.Package id) ->
      Page.Package id
    Just (Route.Standalone id) ->
      Page.Standalone id
    Just Route.Deployments ->
      Page.Deployments

errorToMessage : Http.Error -> String
errorToMessage error =
  case error of
    Http.BadUrl url -> "The URL " ++ url ++ " doesn't exist"
    Http.Timeout -> "The server timed out"
    Http.NetworkError -> "The server couldn't be found"
    Http.BadStatus status -> String.fromInt status ++ " - Une erreur est survenue"
    Http.BadBody err -> err

port updateConfig : Config -> Cmd msg
port updateEnvironment : String -> Cmd msg
