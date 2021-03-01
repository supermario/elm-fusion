module Fusion.HTTP exposing (..)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Fusion.Json
import Fusion.Types exposing (..)
import Http
import Json.Decode as D
import List.Extra as List
import Task exposing (Task)
import Types exposing (..)


type alias Model =
    FrontendModel


type alias Msg =
    FrontendMsg


emptyRequest : Request
emptyRequest =
    { method = POST
    , headers = []
    , url = ""
    , body = StringBody "application/x-www-form-urlencoded" ""
    , timeout = Nothing
    }


toHttpRequest : (Result Http.Error String -> BackendMsg) -> Fusion.Types.Request -> Cmd BackendMsg
toHttpRequest msg req =
    Http.request
        { method = "POST" -- @TODO fix conversion
        , headers = req.headers
        , url = req.url
        , body = toHttpBody req.body
        , expect = Http.expectString msg
        , timeout = Nothing
        , tracker = Nothing
        }


toHttpBody body =
    case body of
        Empty ->
            Http.emptyBody

        StringBody mime string ->
            Http.stringBody mime string

        Json ->
            Debug.todo "Json toHttpBody"

        File ->
            Debug.todo "File toHttpBody"

        Bytes ->
            Debug.todo "Bytes toHttpBody"

        MultiPart parts ->
            Debug.todo "MultiPart toHttpBody"


newRaw : String -> Model -> Model
newRaw string model =
    { model | rawString = string }


guessElmTypeForJsonValue jv =
    case jv of
        JInt int ->
            TInt

        JFloat float ->
            TFloat

        JString string ->
            TString

        JBool bool ->
            TBool

        JNull ->
            TUnimplemented

        JList jvs ->
            TUnimplemented

        JObject fields ->
            TUnimplemented


fusionAddField fieldName jv decoder =
    case decoder of
        EmptyDecoder ->
            FusionType <| TRecord "Unknown" [] [ ( fieldName, guessElmTypeForJsonValue jv ) ]

        FusionType ttype ->
            case ttype of
                TRecord name tParams fields ->
                    FusionType <|
                        TRecord name
                            tParams
                            (fields
                                |> List.append [ ( fieldName, guessElmTypeForJsonValue jv ) ]
                                |> List.uniqueBy (\( n, f ) -> n)
                                |> List.sortBy (\( n, f ) -> n)
                            )

                _ ->
                    -- Cannot add fields to non-record type
                    FusionType <| ttype



-- Record (List.append fields [ fieldName ] |> List.unique)


view : Model -> Element Msg
view model =
    column [ width fill, spacing 10 ]
        [ Input.text []
            { onChange = RequestUrlChanged
            , text = model.currentRequest.url
            , placeholder =
                Just (Input.placeholder [] <| text "type your URL here")
            , label = Input.labelHidden "request url input"
            }
        , Input.multiline []
            { onChange = RequestBodyChanged
            , text = requestBodyString model.currentRequest
            , placeholder = Just (Input.placeholder [] <| text "type your request body")
            , label = Input.labelHidden "request body input"
            , spellcheck = False
            }
        , el
            [ onClick RequestExecClicked
            , Background.color grey
            , padding 10
            , pointer
            ]
          <|
            text "Exec"
        , paragraph [] [ text <| Debug.toString model.currentRequest ]
        , paragraph [] [ text <| Debug.toString model.fusionDecoder ]
        , case D.decodeString decodeJsonAst model.rawString of
            Ok ast ->
                row [ width fill, spacing 20 ]
                    [ column [ width fill, Font.family [ Font.monospace ] ] [ viewAst [] ast ]
                    , column [ width fill, Font.family [ Font.monospace ], alignTop ] [ viewFusionDecoder model ]
                    ]

            Err err ->
                text <| D.errorToString err
        ]


updateCurrentRequest : (Request -> Request) -> Model -> Model
updateCurrentRequest fn model =
    { model | currentRequest = fn model.currentRequest }


updateRequestBodyString : String -> Request -> Request
updateRequestBodyString s req =
    { req
        | body =
            case req.body of
                Empty ->
                    req.body

                StringBody mime string ->
                    StringBody mime s

                Json ->
                    req.body

                File ->
                    req.body

                Bytes ->
                    req.body

                MultiPart parts ->
                    req.body
    }


requestBodyString req =
    case req.body of
        Empty ->
            ""

        StringBody mime string ->
            string

        Json ->
            ""

        File ->
            ""

        Bytes ->
            ""

        MultiPart parts ->
            ""


viewFusionDecoder model =
    case model.fusionDecoder of
        EmptyDecoder ->
            text "Click on a JSON field value to get started!"

        FusionType ttype ->
            text <| Fusion.Json.decoderFromTType ttype


viewAst parents ast =
    case ast of
        JInt int ->
            paragraph [ Font.color orange ] [ text <| String.fromInt int ]

        JFloat float ->
            paragraph [ Font.color orange ] [ text <| String.fromFloat float ]

        JString string ->
            paragraph [ Font.color green, width (fill |> maximum 300) ] [ text <| "\"" ++ string ++ "\"" ]

        JBool bool ->
            text <|
                case bool of
                    True ->
                        "true"

                    False ->
                        "false"

        JNull ->
            text "null"

        JList list ->
            list
                |> List.map (viewAst parents)
                -- |> List.intersperse (text ",")
                |> column [ spacing 10 ]

        JObject fields ->
            column [ spacing 10 ]
                [ el
                    [ onClick <| JsonAddAll parents ast
                    , Background.color blue
                    , pointer
                    , padding 5
                    , alignTop
                    ]
                  <|
                    text "Add all"
                , fields
                    |> List.map
                        (\( field, jv ) ->
                            row
                                [ onClick <| JsonAddField parents field jv
                                , pointer
                                , mouseOver [ Background.color grey ]
                                ]
                                [ el [ alignTop ] <| text <| field ++ ": "
                                , viewAst (parents ++ [ field ]) jv
                                ]
                        )
                    |> column [ spacing 10 ]
                ]


decodeJsonAst : D.Decoder JsonValue
decodeJsonAst =
    D.oneOf
        [ D.int |> D.map JInt
        , D.float |> D.map JFloat
        , D.string |> D.map JString
        , D.bool |> D.map JBool
        , D.null () |> D.map (\_ -> JNull)
        , D.list (D.lazy (\_ -> decodeJsonAst)) |> D.map JList
        , D.keyValuePairs (D.lazy (\_ -> decodeJsonAst)) |> D.map JObject
        ]
