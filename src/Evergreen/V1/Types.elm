module Evergreen.V1.Types exposing (..)

import Dict
import Evergreen.V1.Fusion.Types
import Http
import Lamdera
import Url


type Page
    = FusionHttp


type alias FrontendModel =
    { key : Lamdera.Key
    , page : Page
    , rawString : String
    , rawHeaders : String
    , fusionDecoder : Evergreen.V1.Fusion.Types.FusionDecoder
    , currentRequest : Evergreen.V1.Fusion.Types.Request
    }


type alias BackendModel =
    { httpCache : Dict.Dict String String
    }


type FrontendMsg
    = UrlClicked Lamdera.UrlRequest
    | UrlChanged Url.Url
    | RequestHttpMethodChanged Evergreen.V1.Fusion.Types.RequestMethod
    | RequestUrlChanged String
    | RequestHeadersChanged String
    | RequestBodyChanged String
    | RequestExecClicked
    | ResetDecoder
    | JsonAddField (List String) String Evergreen.V1.Fusion.Types.JsonValue
    | JsonAddAll (List String) Evergreen.V1.Fusion.Types.JsonValue
    | NoOpFrontendMsg


type ToBackend
    = RequestExecClicked_ Evergreen.V1.Fusion.Types.Request
    | NoOpToBackend


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | RequestExecResult Lamdera.ClientId (Result Http.Error String)
    | NoOpBackendMsg


type ToFrontend
    = FusionHttpTarget String
    | RequestExecResult_ (Result Http.Error String)
    | NoOpToFrontend
