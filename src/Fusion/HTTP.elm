module Fusion.HTTP exposing (..)

import Colors exposing (..)
import CurlGenerator
import DataSourceGenerator
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Element.Lazy
import Elm
import ElmHttpGenerator
import Fusion.Json
import Fusion.Operation as Op
import Fusion.Transform
import Fusion.Types exposing (..)
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
import VariableDefinition exposing (VariableDefinition(..))
import View.DecodePreview
import View.Helpers exposing (..)
import View.InteractiveJson


type alias Model =
    FrontendModel


type alias Msg =
    FrontendMsg


emptyRequest : Request
emptyRequest =
    { method = Request.GET
    , headers = []
    , url = "https://jsonplaceholder.typicode.com/posts/1" |> InterpolatedField.fromString
    , body = Fusion.Types.Empty
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


toHttpRequestTask : Dict String VariableDefinition -> Request -> Task HttpError String
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
            Http.stringBody "application/json" string

        Fusion.Types.JsonBody json ->
            json
                |> D.decodeString D.value
                |> Result.map Http.jsonBody
                |> Result.withDefault Http.emptyBody


variablesView : Dict String VariableDefinition -> Request -> Element Msg
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
        section "Variables"
            (allVariables
                |> List.map (variableView variables unreferencedVariables)
            )


variableView : Dict String VariableDefinition -> Set String -> String -> Element Msg
variableView variables unreferencedVariables variableName =
    case variables |> Dict.get variableName |> Maybe.withDefault VariableDefinition.default of
        VariableDefinition variableValue variableVisibility ->
            row [ width fill ]
                [ Input.newPassword [ padding 5 ]
                    { onChange = \newValue -> VariableUpdated { name = variableName, value = VariableDefinition newValue variableVisibility }
                    , text = variableValue
                    , placeholder = Just (Input.placeholder [] <| text "the value for the variable")
                    , label = Input.labelLeft [ paddingEach { top = 0, bottom = 0, left = 0, right = 10 } ] (text variableName)
                    , show = variableVisibility /= VariableDefinition.Secret
                    }
                , if unreferencedVariables |> Set.member variableName then
                    button [] (DeleteVariable variableName) "DELETE"

                  else
                    text ""
                , row []
                    [ buttonHilightOnSvg .notVisible
                        (variableVisibility == VariableDefinition.Secret)
                        []
                        (VariableUpdated { name = variableName, value = VariableDefinition variableValue VariableDefinition.Secret })
                        "Secret"
                    , buttonHilightOnSvg .visible
                        (variableVisibility == VariableDefinition.Parameter)
                        []
                        (VariableUpdated { name = variableName, value = VariableDefinition variableValue VariableDefinition.Parameter })
                        "Parameter"
                    ]
                ]


bodyView : { a | body : RequestBody } -> Element FrontendMsg
bodyView currentRequest =
    let
        currentBodyString : String
        currentBodyString =
            case currentRequest.body of
                Empty ->
                    ""

                JsonBody body ->
                    body

                StringBody mimeType body ->
                    body

        validationErrors : List String
        validationErrors =
            case currentRequest.body of
                Empty ->
                    []

                JsonBody body ->
                    case body |> D.decodeString D.value of
                        Ok _ ->
                            []

                        Err jsonError ->
                            [ D.errorToString jsonError ]

                StringBody _ _ ->
                    []
    in
    column [ width fill ]
        [ row []
            [ buttonHilightOn (currentRequest.body == Empty) [] (RequestBodyChanged Empty) "Empty"
            , buttonHilightOn
                (case currentRequest.body of
                    JsonBody _ ->
                        True

                    _ ->
                        False
                )
                []
                (RequestBodyChanged (JsonBody currentBodyString))
                "JSON"
            ]
        , if currentRequest.body == Empty then
            Element.none

          else
            Input.multiline
                ((if List.isEmpty validationErrors then
                    []

                  else
                    [ Element.Border.color (Element.rgb255 255 0 0) ]
                 )
                    ++ [ padding 5
                       ]
                )
                { onChange =
                    \newBody ->
                        RequestBodyChanged
                            (case currentRequest.body of
                                Empty ->
                                    StringBody "" newBody

                                JsonBody _ ->
                                    JsonBody newBody

                                StringBody mimeType _ ->
                                    StringBody mimeType newBody
                            )
                , text = requestBodyString currentRequest
                , placeholder = Just (Input.placeholder [] <| text "request body")
                , label = Input.labelHidden "request body input"
                , spellcheck = False
                }
        , if List.isEmpty validationErrors then
            Element.none

          else
            Element.column [] (validationErrors |> List.map Element.text)
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


view : Model -> Element Msg
view model =
    column [ width fill, spacing 20 ]
        [ Element.Lazy.lazy2 variablesView model.variables model.currentRequest
        , section "Request builder"
            [ row [ spacing 5 ]
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
            , bodyView model.currentRequest
            , authView model.currentRequest.auth
            ]
        , section "HTTP Request Status"
            [ paragraph []
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
            ]

        -- , paragraph [] [ text <| toString model.currentRequest ]
        -- , paragraph [] [ text <| toString model.fusionDecoder ]
        , case model.httpRequest of
            Success string ->
                case D.decodeString decodeJsonAst string of
                    Ok ast ->
                        column [ width fill, spacing 20 ]
                            [ row [ width fill, spacing 20 ]
                                [ column [ width (fillPortion 5), alignTop, spacing 20 ]
                                    [ section "Interactive JSON response"
                                        [ View.InteractiveJson.fromJsonValue [] ast
                                        ]
                                    , section "Response JSON inferred type"
                                        [ row [ width fill, alignTop, spacing 20 ]
                                            [ el [ width fill, alignTop ] <|
                                                el [ alignTop, Font.family [ Font.monospace ], width fill ] <|
                                                    text <|
                                                        Fusion.View.typeString 0 <|
                                                            Fusion.Transform.mapToType <|
                                                                Op.guessElmTypeForJsonValue ast Root
                                            , el [ width fill, alignTop ] <|
                                                Fusion.View.viewType Nothing <|
                                                    Op.guessElmTypeForJsonValue ast Root
                                            ]
                                        ]
                                    ]
                                , row [ width (fillPortion 6), spacing 20, alignTop ]
                                    [ section "Type builder" <|
                                        case model.fusionDecoder of
                                            EmptyDecoder ->
                                                [ text "Click on a JSON response value label on the left to get started!" ]

                                            FusionType mtype ->
                                                [ column [ width fill, alignTop, spacing 10 ]
                                                    [ Fusion.View.viewType (Just { delete = FusionRemoveField }) <| Fusion.Transform.decoderToMType model.fusionDecoder
                                                    , button [] ResetDecoder "Reset"
                                                    ]
                                                ]
                                    , section "Decode preview" <|
                                        case model.fusionDecoder of
                                            EmptyDecoder ->
                                                [ text "{}" ]

                                            FusionType mtype ->
                                                [ column [ width fill, alignTop ]
                                                    [ View.DecodePreview.view <| Fusion.Transform.extractVType mtype ast
                                                    ]
                                                ]
                                    ]
                                ]
                            , section "Code generators"
                                [ row [ spacing 5 ]
                                    [ buttonHilightOn (model.codeGenMode == ElmPages) [] (CodeGenModeChanged ElmPages) "elm-pages DataSource"
                                    , buttonHilightOn (model.codeGenMode == ElmHttp) [] (CodeGenModeChanged ElmHttp) "elm/http Request"
                                    , buttonHilightOn (model.codeGenMode == Curl) [] (CodeGenModeChanged Curl) "cURL"
                                    ]
                                , generatedRequestView model
                                ]
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


section title children =
    column [ Background.color charcoal, width fill, padding 2, alignTop ]
        [ el [ padding_ 2 5 5 4, Font.size 10, Font.color white ] <| text title
        , column [ Background.color white, width fill, spacing 20, padding 10 ] children
        ]


generatedRequestView : Model -> Element msg
generatedRequestView model =
    el
        [ Font.family [ Font.monospace ]
        , padding 10
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

                FusionType mtype ->
                    Fusion.Json.decoderFromMType 0 mtype
    in
    """import DataSource.Http
import Pages.Secrets
import OptimizedDecoder as D
import OptimizedDecoder.Pipeline exposing (required)

"""
        ++ (model.currentRequest
                |> DataSourceGenerator.generate model.variables
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

                        FusionType mType ->
                            Fusion.Json.decoderFromMType 0 mType
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


updateRequestBodyString : RequestBody -> Request -> Request
updateRequestBodyString s req =
    { req | body = s }


requestBodyString : { a | body : RequestBody } -> String
requestBodyString req =
    case req.body of
        Empty ->
            ""

        StringBody contentType body ->
            body

        JsonBody body ->
            body


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
