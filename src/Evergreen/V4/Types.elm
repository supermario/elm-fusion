module Evergreen.V4.Types exposing (..)

import Dict
import Evergreen.V4.Fusion.Types
import Evergreen.V4.Request
import Evergreen.V4.VariableDefinition
import Lamdera
import RemoteData


type Page
    = FusionHttp
    | TestVisual


type CodeGenMode
    = ElmPages
    | ElmHttp
    | Curl


type alias FrontendModel =
    { key : Lamdera.Key
    , page : Page
    , rawHeaders : String
    , fusionDecoder : Evergreen.V4.Fusion.Types.FusionDecoder
    , currentRequest : Evergreen.V4.Request.Request
    , lastPerformed :
        Maybe
            { request : Evergreen.V4.Request.Request
            , variables : Dict.Dict String Evergreen.V4.VariableDefinition.VariableDefinition
            }
    , httpRequest : RemoteData.RemoteData Evergreen.V4.Fusion.Types.HttpError String
    , codeGenMode : CodeGenMode
    , variables : Dict.Dict String Evergreen.V4.VariableDefinition.VariableDefinition
    }


type alias BackendModel =
    { httpCache : Dict.Dict String String
    , httpRequest : RemoteData.RemoteData Evergreen.V4.Fusion.Types.HttpError String
    }


type FrontendMsg
    = UrlClicked Lamdera.UrlRequest
    | UrlChanged Lamdera.Url
    | RequestHttpMethodChanged Evergreen.V4.Request.Method
    | CodeGenModeChanged CodeGenMode
    | RequestUrlChanged String
    | VariableUpdated
        { name : String
        , value : Evergreen.V4.VariableDefinition.VariableDefinition
        }
    | DeleteVariable String
    | RequestHeadersChanged String
    | RequestBodyChanged String
    | AuthChanged (Maybe Evergreen.V4.Request.Auth)
    | MakeRequestClicked
    | ResetDecoder
    | JsonAddField (List String) String Evergreen.V4.Fusion.Types.JsonValue
    | JsonAddAll (List String) Evergreen.V4.Fusion.Types.JsonValue
    | FusionRemoveField Evergreen.V4.Fusion.Types.MType
    | NoOpFrontendMsg


type ToBackend
    = MakeRequestClicked_ (Dict.Dict String Evergreen.V4.VariableDefinition.VariableDefinition) Evergreen.V4.Request.Request
    | NoOpToBackend


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | RequestExecResult Lamdera.ClientId (Result Evergreen.V4.Fusion.Types.HttpError String)
    | NoOpBackendMsg


type ToFrontend
    = RequestExecResult_ (Result Evergreen.V4.Fusion.Types.HttpError String)
    | NoOpToFrontend
