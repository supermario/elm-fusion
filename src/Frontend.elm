module Frontend exposing (..)

import Browser exposing (UrlRequest(..), application)
import Browser.Navigation as Navigation
import Colors exposing (..)
import Dict
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Env
import Fusion.HTTP exposing (..)
import Fusion.Types exposing (..)
import Helpers exposing (..)
import Html
import Http
import Json.Decode as Json
import Lamdera exposing (..)
import OAuth
import OAuth.AuthorizationCode as OAuth
import Page
import RemoteData exposing (RemoteData(..))
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
      , rawString = ""
      , rawHeaders = ""
      , fusionDecoder = Fusion.Types.EmptyDecoder
      , currentRequest = Fusion.HTTP.emptyRequest
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
            ( model
                |> updateCurrentRequest
                    (\req ->
                        { req | url = s }
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
                                                    Just (Http.header (String.trim n) (String.trim v))

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

        RequestExecClicked ->
            ( { model | rawString = "" }, sendToBackend (RequestExecClicked_ model.currentRequest) )

        ResetDecoder ->
            ( { model | fusionDecoder = EmptyDecoder }, Cmd.none )

        JsonAddField parents f jv ->
            ( { model | fusionDecoder = fusionAddField f jv model.fusionDecoder }, Cmd.none )

        JsonAddAll parents jv ->
            case jv of
                JObject fields ->
                    fields
                        |> List.foldl
                            (\( f, v ) m ->
                                { m | fusionDecoder = fusionAddField f jv m.fusionDecoder }
                            )
                            model
                        |> (\m -> ( m, Cmd.none ))

                _ ->
                    Debug.todo <| "todo JsonAddAll" ++ Debug.toString ( parents, jv )

        NoOpFrontendMsg ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        FusionHttpTarget string ->
            ( model |> Fusion.HTTP.newRaw string, Cmd.none )

        RequestExecResult_ res ->
            case res of
                Ok string ->
                    ( { model | rawString = string }
                    , Cmd.none
                    )

                Err err ->
                    let
                        x =
                            Debug.log "error:" err
                    in
                    ( model, Cmd.none )

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
                , column [ width fill, height fill, padding 20 ]
                    [ case model.page of
                        FusionHttp ->
                            Fusion.HTTP.view model
                    ]
                ]
        ]
    }


viewElmUi children =
    layout [ Font.family [ Font.typeface "Roboto" ], Font.size 14, width fill, height fill ] <| children


nav =
    row [ spacing 10, paddingXY 20 10, Background.color blue, width fill, Font.color white ]
        [ text "elm-http-fusion"
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
