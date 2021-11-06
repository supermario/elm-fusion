module Evergreen.V3.Types exposing (..)

import Dict
import Evergreen.V3.Fusion.Types
import Evergreen.V3.Request
import Evergreen.V3.VariableDefinition
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
    , rawHeaders : String
    , fusionDecoder : Evergreen.V3.Fusion.Types.FusionDecoder
    , currentRequest : Evergreen.V3.Request.Request
    , lastPerformed :
        Maybe
            { request : Evergreen.V3.Request.Request
            , variables : Dict.Dict String Evergreen.V3.VariableDefinition.VariableDefinition
            }
    , httpRequest : RemoteData.RemoteData Evergreen.V3.Fusion.Types.HttpError String
    , codeGenMode : CodeGenMode
    , variables : Dict.Dict String Evergreen.V3.VariableDefinition.VariableDefinition
    }


type alias BackendModel =
    { httpCache : Dict.Dict String String
    , httpRequest : RemoteData.RemoteData Evergreen.V3.Fusion.Types.HttpError String
    }


type FrontendMsg
    = UrlClicked Lamdera.UrlRequest
    | UrlChanged Lamdera.Url
    | RequestHttpMethodChanged Evergreen.V3.Request.Method
    | CodeGenModeChanged CodeGenMode
    | RequestUrlChanged String
    | VariableUpdated
        { name : String
        , value : Evergreen.V3.VariableDefinition.VariableDefinition
        }
    | DeleteVariable String
    | RequestHeadersChanged String
    | RequestBodyChanged String
    | AuthChanged (Maybe Evergreen.V3.Request.Auth)
    | MakeRequestClicked
    | ResetDecoder
    | JsonAddField (List String) String Evergreen.V3.Fusion.Types.JsonValue
    | JsonAddAll (List String) Evergreen.V3.Fusion.Types.JsonValue
    | NoOpFrontendMsg


type ToBackend
    = MakeRequestClicked_ (Dict.Dict String Evergreen.V3.VariableDefinition.VariableDefinition) Evergreen.V3.Request.Request
    | NoOpToBackend


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | RequestExecResult Lamdera.ClientId (Result Evergreen.V3.Fusion.Types.HttpError String)
    | NoOpBackendMsg


type ToFrontend
    = RequestExecResult_ (Result Evergreen.V3.Fusion.Types.HttpError String)
    | NoOpToFrontend
