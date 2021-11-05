module Backend exposing (..)

import Dict exposing (Dict)
import Fusion.HTTP
import Fusion.Types
import Helpers exposing (..)
import Html
import Http
import Json.Decode as Decode
import Lamdera exposing (..)
import RemoteData
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
      , httpRequest = RemoteData.NotAsked
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
            ( { model | httpRequest = RemoteData.fromResult res }
            , sendToFrontend clientId (RequestExecResult_ res)
            )

        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        MakeRequestClicked_ variables request ->
            ( { model | httpRequest = RemoteData.Loading }
            , request |> Fusion.HTTP.toHttpRequestTask variables |> Task.attempt (RequestExecResult clientId)
            )

        NoOpToBackend ->
            ( model, Cmd.none )
