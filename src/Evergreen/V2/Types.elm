module Evergreen.V2.Types exposing (..)

import Dict
import Evergreen.V2.Fusion.Types
import Evergreen.V2.Request
import Lamdera
import RemoteData


type Page
    = FusionHttp


type CodeGenMode
    = ElmPages
    | ElmHttp
    | Curl


type alias FrontendModel =
    { key : Lamdera.Key
    , page : Page
    , rawString : String
    , rawHeaders : String
    , fusionDecoder : Evergreen.V2.Fusion.Types.FusionDecoder
    , currentRequest : Evergreen.V2.Request.Request
    , httpRequest : RemoteData.RemoteData Evergreen.V2.Fusion.Types.HttpError String
    , codeGenMode : CodeGenMode
    }


type alias BackendModel =
    { httpCache : Dict.Dict String String
    , httpRequest : RemoteData.RemoteData Evergreen.V2.Fusion.Types.HttpError String
    }


type FrontendMsg
    = UrlClicked Lamdera.UrlRequest
    | UrlChanged Lamdera.Url
    | RequestHttpMethodChanged Evergreen.V2.Request.Method
    | CodeGenModeChanged CodeGenMode
    | RequestUrlChanged String
    | RequestHeadersChanged String
    | RequestBodyChanged String
    | RequestExecClicked
    | ResetDecoder
    | JsonAddField (List String) String Evergreen.V2.Fusion.Types.JsonValue
    | JsonAddAll (List String) Evergreen.V2.Fusion.Types.JsonValue
    | NoOpFrontendMsg


type ToBackend
    = RequestExecClicked_ Evergreen.V2.Request.Request
    | NoOpToBackend


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | RequestExecResult Lamdera.ClientId (Result Evergreen.V2.Fusion.Types.HttpError String)
    | NoOpBackendMsg


type ToFrontend
    = FusionHttpTarget String
    | RequestExecResult_ (Result Evergreen.V2.Fusion.Types.HttpError String)
    | NoOpToFrontend
