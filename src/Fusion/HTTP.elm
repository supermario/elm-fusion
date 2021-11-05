module Fusion.HTTP exposing (..)

import Colors exposing (..)
import CurlGenerator
import DataSourceGenerator
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Element.Lazy
import Elm
import ElmHttpGenerator
import Fusion.Json
import Fusion.Types exposing (FusionDecoder(..), HttpError, JsonValue(..), TType(..))
import Fusion.View
import Helpers exposing (..)
import Http exposing (..)
import InterpolatedField
import Json.Decode as D
import List.Extra as List
import RemoteData exposing (..)
import Request exposing (Request)
import Set exposing (Set)
import Task exposing (Task)
import Types exposing (..)
import View.Helpers exposing (..)


type alias Model =
    FrontendModel


type alias Msg =
    FrontendMsg


emptyRequest : Request
emptyRequest =
    { method = Request.GET
    , headers = []
    , url = "https://jsonplaceholder.typicode.com/posts/1" |> InterpolatedField.fromString
    , body = Request.StringBody "application/x-www-form-urlencoded" ""
    , timeout = Nothing
    , auth = Nothing
    }



-- toHttpRequest : (Result Http.Error String -> BackendMsg) -> Fusion.Types.Request -> Cmd BackendMsg
-- toHttpRequest msg req =
--     Http.request
--         { method = toHttpMethod req.method
--         , headers = req.headers
--         , url = req.url
--         , body = toHttpBody req.body
--         , expect = Http.expectString msg
--         , timeout = Nothing
--         , tracker = Nothing
--         }


toHttpRequestTask : Dict String String -> Request -> Task HttpError String
toHttpRequestTask variables request =
    let
        req : Fusion.Types.Request
        req =
            Request.convert variables request
    in
    Http.task
        { method = toHttpMethod req.method
        , headers = req.headers
        , url = req.url
        , body = toHttpBody req.body
        , resolver = stringResolver_
        , timeout = Nothing
        }


toHttpBody : Fusion.Types.RequestBody -> Http.Body
toHttpBody body =
    case body of
        Fusion.Types.Empty ->
            Http.emptyBody

        Fusion.Types.StringBody mime string ->
            Http.stringBody mime string

        Fusion.Types.Json ->
            todo "Json toHttpBody" Http.emptyBody

        Fusion.Types.File ->
            todo "File toHttpBody" Http.emptyBody

        Fusion.Types.Bytes ->
            todo "Bytes toHttpBody" Http.emptyBody

        Fusion.Types.MultiPart parts ->
            todo "MultiPart toHttpBody" Http.emptyBody


variablesView : Dict String String -> Request -> Element Msg
variablesView variables request =
    let
        referencedVariables : List String
        referencedVariables =
            Request.referencedVariables request
                |> List.map InterpolatedField.rawVariableName

        definedVariables : List String
        definedVariables =
            variables
                |> Dict.keys

        allVariables : List String
        allVariables =
            (referencedVariables ++ definedVariables)
                |> List.unique

        unreferencedVariables : Set String
        unreferencedVariables =
            Set.diff
                (Set.fromList definedVariables)
                (Set.fromList referencedVariables)
    in
    if allVariables |> List.isEmpty then
        text ""

    else
        column [ width fill, spacing 5 ]
            (el [ Font.size 16, paddingXY 0 10 ] (text "Variables")
                :: (allVariables
                        |> List.map (variableView variables unreferencedVariables)
                   )
            )


variableView : Dict String String -> Set String -> String -> Element Msg
variableView variables unreferencedVariables variableName =
    row []
        [ Input.text [ padding 5 ]
            { onChange = \value -> VariableUpdated { name = variableName, value = value }
            , text = variables |> Dict.get variableName |> Maybe.withDefault ""
            , placeholder = Just (Input.placeholder [] <| text "the value for the variable")
            , label = Input.labelLeft [ paddingEach { top = 0, bottom = 0, left = 0, right = 10 } ] (text variableName)
            }
        , if unreferencedVariables |> Set.member variableName then
            button [] (DeleteVariable variableName) "DELETE"

          else
            text ""
        ]


authView : Maybe Request.Auth -> Element Msg
authView maybeAuth =
    -- TODO button to toggle between different auth types (for now just Basic or None)
    column []
        [ row []
            [ buttonHilightOn (maybeAuth == Nothing) [] (AuthChanged Nothing) "None"
            , buttonHilightOn
                (case maybeAuth of
                    Just (Request.BasicAuth _) ->
                        True

                    _ ->
                        False
                )
                []
                (AuthChanged (Just (Request.BasicAuth { username = "" |> InterpolatedField.fromString, password = "" |> InterpolatedField.fromString })))
                "Basic"
            ]
        , case maybeAuth of
            Just (Request.BasicAuth basicAuth) ->
                column [ width fill ]
                    [ Input.text [ padding 5 ]
                        { onChange = \value -> AuthChanged (Just (Request.BasicAuth { basicAuth | username = value |> InterpolatedField.fromString }))
                        , text = basicAuth.username |> InterpolatedField.toString
                        , placeholder = Just (Input.placeholder [] <| text "")
                        , label = Input.labelLeft [ paddingEach { top = 0, bottom = 0, left = 0, right = 10 } ] (text "Username")
                        }
                    , Input.currentPassword [ padding 5 ]
                        { onChange = \value -> AuthChanged (Just (Request.BasicAuth { basicAuth | password = value |> InterpolatedField.fromString }))
                        , text = basicAuth.password |> InterpolatedField.toString
                        , placeholder = Just (Input.placeholder [] <| text "")
                        , show = True
                        , label = Input.labelLeft [ paddingEach { top = 0, bottom = 0, left = 0, right = 10 } ] (text "Password")
                        }
                    ]

            Nothing ->
                column [] []
        ]


toHttpMethod : Fusion.Types.RequestMethod -> String
toHttpMethod method =
    case method of
        Fusion.Types.GET ->
            "GET"

        Fusion.Types.POST ->
            "POST"


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
            TMaybe (TParam "unknown")

        JList jvs ->
            case jvs of
                v :: _ ->
                    TList <| guessElmTypeForJsonValue v

                [] ->
                    TList (TParam "unknown")

        JObject fields ->
            fields
                |> List.map (\( name, jv_ ) -> ( name, guessElmTypeForJsonValue jv_ ))
                |> TRecord "Unknown" []


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
        [ Element.Lazy.lazy2 variablesView model.variables model.currentRequest
        , row [ spacing 5 ]
            [ buttonHilightOn (model.currentRequest.method == Request.GET) [] (RequestHttpMethodChanged Request.GET) "GET"
            , buttonHilightOn (model.currentRequest.method == Request.POST) [] (RequestHttpMethodChanged Request.POST) "POST"
            , el
                [ onClick MakeRequestClicked
                , if model.lastPerformed == Just { request = model.currentRequest, variables = model.variables } then
                    Background.color grey

                  else
                    Background.color green
                , padding 10
                , pointer
                ]
              <|
                text "Make Request"
            ]
        , Input.multiline [ padding 5 ]
            { onChange = RequestUrlChanged
            , text = model.currentRequest.url |> InterpolatedField.toString
            , placeholder =
                Just (Input.placeholder [] <| text "the HTTP URL")
            , label = Input.labelHidden "request url input"
            , spellcheck = False
            }
        , Input.multiline [ padding 5 ]
            { onChange = RequestHeadersChanged
            , text = model.rawHeaders
            , placeholder = Just (Input.placeholder [] <| text "request headers, one per line")
            , label = Input.labelHidden "request headers input"
            , spellcheck = False
            }
        , Input.multiline [ padding 5 ]
            { onChange = RequestBodyChanged
            , text = requestBodyString model.currentRequest
            , placeholder = Just (Input.placeholder [] <| text "request body")
            , label = Input.labelHidden "request body input"
            , spellcheck = False
            }
        , authView model.currentRequest.auth
        , paragraph []
            [ case model.httpRequest of
                NotAsked ->
                    text "No HTTP requests yet."

                Loading ->
                    text "Loading..."

                Failure err ->
                    text <| "Error: " ++ httpErrorToString err

                Success v ->
                    text "HTTP succeeded."
            ]

        -- , paragraph [] [ text <| toString model.currentRequest ]
        , paragraph [] [ text <| toString model.fusionDecoder ]
        , case model.httpRequest of
            Success string ->
                case D.decodeString decodeJsonAst string of
                    Ok ast ->
                        column [ width fill, spacing 10 ]
                            [ row [ width fill, spacing 20 ]
                                [ column [ width fill, Font.family [ Font.monospace ], alignTop ] [ viewAst [] ast ]
                                , column [ width fill, Font.family [ Font.monospace ], alignTop, spacing 20 ]
                                    [ button [] ResetDecoder "Reset"
                                    , viewFusionDecoder model
                                    , viewFusionJsonInferredTypeString ast
                                    , viewFusionJsonInferredTypeRich ast
                                    ]
                                ]
                            , row [ spacing 5 ]
                                [ buttonHilightOn (model.codeGenMode == ElmPages) [] (CodeGenModeChanged ElmPages) "elm-pages DataSource"
                                , buttonHilightOn (model.codeGenMode == ElmHttp) [] (CodeGenModeChanged ElmHttp) "elm/http Request"
                                , buttonHilightOn (model.codeGenMode == Curl) [] (CodeGenModeChanged Curl) "cURL"
                                ]
                            , generatedRequestView model
                            ]

                    Err err ->
                        column [ spacing 10 ]
                            [ paragraph [] [ text <| "I got a valid response: " ]
                            , el [ Font.family [ Font.monospace ] ] <| text string
                            , paragraph [] [ text "But failed to decode it into JSON:" ]
                            , text <| D.errorToString err
                            ]

            _ ->
                none
        ]


generatedRequestView : Model -> Element msg
generatedRequestView model =
    el
        [ Font.family [ Font.monospace ]
        ]
        ((case model.codeGenMode of
            ElmPages ->
                elmPagesCodeGen model

            ElmHttp ->
                elmHttpCodeGen model

            Curl ->
                CurlGenerator.generate model.currentRequest
         )
            |> text
        )


elmPagesCodeGen : Model -> String
elmPagesCodeGen model =
    let
        decoderString =
            case model.fusionDecoder of
                EmptyDecoder ->
                    "D.fail \"TODO you can create a decoder through the UI above\""

                FusionType tType ->
                    Fusion.Json.decoderFromTType tType
    in
    """import DataSource.Http
import Pages.Secrets
import OptimizedDecoder as D
import OptimizedDecoder.Pipeline exposing (required)

"""
        ++ (model.currentRequest
                |> DataSourceGenerator.generate
                |> Elm.declarationToString
           )
        ++ "\n\ndecoder =\n"
        ++ indent decoderString


elmHttpCodeGen : Model -> String
elmHttpCodeGen model =
    let
        decoderString : String
        decoderString =
            "\n\ndecoder =\n"
                ++ ((case model.fusionDecoder of
                        EmptyDecoder ->
                            "D.fail \"TODO you can create a decoder through the UI above\""

                        FusionType tType ->
                            Fusion.Json.decoderFromTType tType
                    )
                        |> indent
                   )
    in
    """import Http
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)


"""
        ++ (model.currentRequest
                |> ElmHttpGenerator.generate
                |> Elm.declarationToString
           )
        ++ decoderString


indent : String -> String
indent string =
    string
        |> String.lines
        |> List.map (\line -> "    " ++ line)
        |> String.join "\n"


updateCurrentRequest : (Request.Request -> Request.Request) -> Model -> Model
updateCurrentRequest fn model =
    { model
        | currentRequest = fn model.currentRequest
    }


updateRequestBodyString : String -> Request -> Request
updateRequestBodyString s req =
    { req
        | body =
            case req.body of
                Request.Empty ->
                    req.body

                Request.StringBody mime string ->
                    Request.StringBody mime string
    }


requestBodyString : { a | body : Request.Body } -> String
requestBodyString req =
    case req.body of
        Request.Empty ->
            ""

        Request.StringBody contentType body ->
            body


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
                [ button [] (JsonAddAll parents ast) "Add all"
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


viewFusionJsonInferredTypeRich ast =
    Fusion.View.viewType <| guessElmTypeForJsonValue ast


viewFusionJsonInferredTypeString ast =
    text <| Fusion.View.typeString 0 <| guessElmTypeForJsonValue ast


httpErrorToString : HttpError -> String
httpErrorToString err =
    case err of
        Fusion.Types.BadUrl url ->
            "HTTP Malformed url: " ++ url

        Fusion.Types.Timeout ->
            "HTTP Timeout exceeded"

        Fusion.Types.NetworkError ->
            "HTTP Network error"

        Fusion.Types.BadStatus code body ->
            "HTTP " ++ String.fromInt code ++ ": " ++ body

        Fusion.Types.BadBody text ->
            "Unexpected HTTP response: " ++ text


stringResolver_ : Http.Resolver HttpError String
stringResolver_ =
    Http.stringResolver <|
        \response ->
            case response of
                Http.GoodStatus_ metadata body ->
                    Ok body

                Http.BadUrl_ message ->
                    Err (Fusion.Types.BadUrl message)

                Http.Timeout_ ->
                    Err Fusion.Types.Timeout

                Http.NetworkError_ ->
                    Err Fusion.Types.NetworkError

                Http.BadStatus_ metadata body ->
                    Err (Fusion.Types.BadStatus metadata.statusCode body)
