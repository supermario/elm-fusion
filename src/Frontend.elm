module Frontend exposing (..)

import Browser exposing (UrlRequest(..), application)
import Browser.Navigation as Navigation
import Cli.OptionsParser.MatchResult exposing (MatchResult)
import Colors exposing (..)
import Curl
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Env
import Fusion.HTTP exposing (..)
import Fusion.JsonTest
import Fusion.Operation
import Fusion.Types exposing (..)
import Helpers exposing (..)
import Html
import Http
import InterpolatedField
import Json.Decode as Json
import Lamdera exposing (..)
import OAuth
import OAuth.AuthorizationCode as OAuth
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Stubs.MType
import Stubs.Response
import Types exposing (..)
import Url exposing (Protocol(..), Url)


type alias Model =
    FrontendModel


type alias Msg =
    FrontendMsg


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Navigation.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , page = Page.pathToPage url
      , rawHeaders = ""
      , fusionDecoder = Fusion.Types.EmptyDecoder

      -- , fusionDecoder = Fusion.Types.FusionType Stubs.MType.basic2LevelRecord
      , currentRequest = Fusion.HTTP.emptyRequest
      , lastPerformed = Nothing
      , httpRequest = NotAsked

      -- , httpRequest = Success Stubs.Response.basic2LevelJson
      , codeGenMode = ElmPages
      , variables = Dict.empty
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            Page.urlClicked model urlRequest

        UrlChanged url ->
            Page.urlChanged model url onPageInit

        RequestHttpMethodChanged method ->
            let
                currentRequest =
                    model.currentRequest

                newReq =
                    { currentRequest | method = method }
            in
            ( { model | currentRequest = newReq }, Cmd.none )

        RequestUrlChanged s ->
            let
                requestThing : Maybe Request.Request
                requestThing =
                    if s |> String.startsWith "curl " then
                        let
                            requestFromCurl : MatchResult Request.Request
                            requestFromCurl =
                                String.dropLeft 4 s
                                    |> Curl.runCurl
                        in
                        case requestFromCurl of
                            Cli.OptionsParser.MatchResult.Match match ->
                                case match of
                                    Ok okMatch ->
                                        Just okMatch

                                    Err matchError ->
                                        Nothing

                            Cli.OptionsParser.MatchResult.NoMatch strings ->
                                Nothing

                    else
                        Nothing
            in
            ( case requestThing of
                Just parsedCurlRequest ->
                    { model
                        | currentRequest = parsedCurlRequest
                        , rawHeaders = parsedCurlRequest.headers |> List.map (\( key, value ) -> InterpolatedField.toString key ++ ": " ++ InterpolatedField.toString value) |> String.join "\n"
                    }

                Nothing ->
                    model
                        |> updateCurrentRequest
                            (\req ->
                                { req | url = InterpolatedField.fromString s }
                            )
            , Cmd.none
            )

        RequestHeadersChanged s ->
            ( { model | rawHeaders = s }
                |> updateCurrentRequest
                    (\req ->
                        { req
                            | headers =
                                s
                                    |> String.split "\n"
                                    |> List.map
                                        (\s_ ->
                                            case String.split ":" s_ of
                                                n :: v :: _ ->
                                                    Just
                                                        ( String.trim n |> InterpolatedField.fromString
                                                        , String.trim v |> InterpolatedField.fromString
                                                        )

                                                _ ->
                                                    Nothing
                                        )
                                    |> justs
                        }
                    )
            , Cmd.none
            )

        RequestBodyChanged s ->
            ( model
                |> updateCurrentRequest
                    (\req ->
                        req |> updateRequestBodyString s
                    )
            , Cmd.none
            )

        MakeRequestClicked ->
            ( { model | httpRequest = Loading }, sendToBackend (MakeRequestClicked_ model.variables model.currentRequest) )

        ResetDecoder ->
            ( { model | fusionDecoder = EmptyDecoder }, Cmd.none )

        JsonAddField parents f jv ->
            ( { model | fusionDecoder = Fusion.Operation.fusionAddField parents f jv model.fusionDecoder }, Cmd.none )

        JsonAddAll parents jv ->
            ( { model | fusionDecoder = Fusion.Operation.fusionAddAll parents jv model.fusionDecoder }, Cmd.none )

        FusionRemoveField mtype ->
            ( { model | fusionDecoder = Fusion.Operation.fusionRemove mtype model.fusionDecoder }, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        CodeGenModeChanged codeGenMode ->
            ( { model | codeGenMode = codeGenMode }, Cmd.none )

        VariableUpdated variableUpdate ->
            ( { model | variables = model.variables |> Dict.update variableUpdate.name (\_ -> Just variableUpdate.value) }
            , Cmd.none
            )

        DeleteVariable variableName ->
            ( { model | variables = model.variables |> Dict.remove variableName }
            , Cmd.none
            )

        AuthChanged maybeAuth ->
            ( model
                |> updateCurrentRequest
                    (\req ->
                        { req | auth = maybeAuth }
                    )
            , Cmd.none
            )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        RequestExecResult_ res ->
            case res of
                Ok string ->
                    ( { model
                        | httpRequest = RemoteData.fromResult res
                        , lastPerformed =
                            Just
                                { request = model.currentRequest
                                , variables = model.variables
                                }
                      }
                    , Cmd.none
                    )

                Err err ->
                    let
                        x =
                            log "error:" err
                    in
                    ( { model | httpRequest = RemoteData.fromResult res }, Cmd.none )

        NoOpToFrontend ->
            ( model, Cmd.none )


onPageInit : Model -> Page -> Cmd FrontendMsg
onPageInit model page =
    Cmd.none


view : Model -> Document Msg
view model =
    { title = Page.pageName model.page
    , body =
        [ staticCss
        , viewElmUi <|
            column [ width fill, height fill ]
                [ nav
                , column [ width fill, height fill, padding 10 ]
                    [ case model.page of
                        FusionHttp ->
                            Fusion.HTTP.view model

                        TestVisual ->
                            Fusion.JsonTest.view
                    ]
                ]
        ]
    }


viewElmUi children =
    layout
        [ Font.family [ Font.typeface "system-ui" ]
        , Font.size 14
        , width fill
        , Background.color grey
        ]
    <|
        children


nav =
    row [ spacing 10, paddingXY 20 10, Background.color blue, width fill, Font.color white ]
        [ text "elm-fusion"
        , el [ alignRight ] <| newTabLink [ Font.underline ] { url = "https://github.com/supermario/elm-http-fusion", label = text "Github" }
        ]


linkTo page =
    link [ Font.underline, mouseOver [ Font.color blue ] ]
        { url = Page.pageToPath page, label = text <| Page.pageName page }


staticCss =
    Html.node "style"
        []
        [ Html.text
            """
    html, body  { height: 100%; background-color: #FBFBF9; }
    """
        ]
