module Types exposing (..)

import Dict exposing (Dict)
import Fusion.Types exposing (..)
import Lamdera exposing (..)
import RemoteData exposing (RemoteData)
import Request


type Page
    = FusionHttp


type alias FrontendModel =
    { key : Key
    , page : Page

    -- Fusion
    , rawHeaders : String
    , fusionDecoder : FusionDecoder
    , currentRequest : Request.Request
    , httpRequest : RemoteData HttpError String
    , codeGenMode : CodeGenMode
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
      -- Fusion
    | RequestHttpMethodChanged Request.Method
    | CodeGenModeChanged CodeGenMode
    | RequestUrlChanged String
    | RequestHeadersChanged String
    | RequestBodyChanged String
    | MakeRequestClicked
    | ResetDecoder
    | JsonAddField (List String) String JsonValue
    | JsonAddAll (List String) JsonValue
    | NoOpFrontendMsg


type CodeGenMode
    = ElmPages
    | ElmHttp
    | Curl


type ToBackend
    = MakeRequestClicked_ Request.Request
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
    = RequestExecResult_ (Result HttpError String)
    | NoOpToFrontend
