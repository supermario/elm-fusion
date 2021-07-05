module Types exposing (..)

import Dict exposing (Dict)
import Fusion.Types exposing (..)
import Http
import Json.Decode as Json
import Lamdera exposing (..)
import RemoteData exposing (RemoteData)
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
    , rawHeaders : String
    , fusionDecoder : FusionDecoder
    , currentRequest : Request
    , httpRequest : RemoteData HttpError String
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
      -- Fusion
    | RequestHttpMethodChanged RequestMethod
    | RequestUrlChanged String
    | RequestHeadersChanged String
    | RequestBodyChanged String
    | RequestExecClicked
    | ResetDecoder
    | JsonAddField (List String) String JsonValue
    | JsonAddAll (List String) JsonValue
    | NoOpFrontendMsg


type ToBackend
    = RequestExecClicked_ Request
    | NoOpToBackend


type alias BackendModel =
    { httpCache : Dict String String
    , httpRequest : RemoteData HttpError String
    }


type BackendMsg
    = ClientConnected SessionId ClientId
    | RequestExecResult ClientId (Result HttpError String)
    | NoOpBackendMsg


type ToFrontend
    = FusionHttpTarget String
    | RequestExecResult_ (Result HttpError String)
    | NoOpToFrontend
