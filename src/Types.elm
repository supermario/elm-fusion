module Types exposing (..)

import Dict exposing (Dict)
import Fusion.Types exposing (..)
import Http
import Json.Decode as Json
import Lamdera exposing (..)
import RemoteData exposing (WebData)
import Task exposing (Task)
import Time
import Url exposing (Url)


type Page
    = FusionHttp


type alias FrontendModel =
    { key : Key
    , page : Page

    -- Fusion
    , rawString : String
    , fusionDecoder : FusionDecoder
    , currentRequest : Request
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
      -- Fusion
    | RequestUrlChanged String
    | RequestBodyChanged String
    | RequestExecClicked
    | JsonAddField (List String) String JsonValue
    | JsonAddAll (List String) JsonValue
    | NoOpFrontendMsg


type ToBackend
    = RequestExecClicked_ Request
    | NoOpToBackend


type alias BackendModel =
    { httpCache : Dict String String
    }


type BackendMsg
    = ClientConnected SessionId ClientId
    | RequestExecResult ClientId (Result Http.Error String)
    | NoOpBackendMsg


type ToFrontend
    = FusionHttpTarget String
    | RequestExecResult_ (Result Http.Error String)
    | NoOpToFrontend
