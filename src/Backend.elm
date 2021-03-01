module Backend exposing (..)

import Dict exposing (Dict)
import Fusion.HTTP
import Fusion.Types
import Helpers exposing (..)
import Html
import Http
import Json.Decode as Decode
import Lamdera exposing (..)
import Task
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.batch [ onConnect ClientConnected ]
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { httpCache = Dict.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected sessionId clientId ->
            ( model
            , Cmd.batch []
            )

        RequestExecResult clientId res ->
            ( model, sendToFrontend clientId (RequestExecResult_ res) )

        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        RequestExecClicked_ request ->
            ( model
            , Fusion.HTTP.toHttpRequest (RequestExecResult clientId) request
            )

        NoOpToBackend ->
            ( model, Cmd.none )
