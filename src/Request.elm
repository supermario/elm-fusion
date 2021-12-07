module Request exposing (Auth(..), Method(..), Request, convert, methodToString, referencedVariables)

import Base64
import Dict exposing (Dict)
import Fusion.Types exposing (RequestBody)
import Http
import InterpolatedField exposing (InterpolatedField)
import List.Extra
import VariableDefinition exposing (VariableDefinition)


type alias Request =
    { method : Method
    , headers : List ( InterpolatedField, InterpolatedField )
    , url : InterpolatedField
    , body : RequestBody
    , timeout : Maybe Float
    , auth : Maybe Auth
    }


type Auth
    = BasicAuth
        { username : InterpolatedField
        , password : InterpolatedField
        }


type Method
    = GET
    | POST


convert : Dict String VariableDefinition -> Request -> Fusion.Types.Request
convert variables request =
    let
        basicAuthEncoded basicAuth =
            "Basic "
                ++ Base64.encode (InterpolatedField.interpolate variables basicAuth.username ++ ":" ++ InterpolatedField.interpolate variables basicAuth.password)

        authHeaders : List ( InterpolatedField, InterpolatedField )
        authHeaders =
            case request.auth of
                Just (BasicAuth basicAuth) ->
                    [ ( InterpolatedField.fromString "Authorization"
                      , InterpolatedField.fromString <| basicAuthEncoded basicAuth
                      )
                    ]

                _ ->
                    []
    in
    { headers =
        (request.headers ++ authHeaders)
            |> List.Extra.uniqueBy (\( key, value ) -> InterpolatedField.interpolate variables key |> String.toLower)
            |> List.filter (\( key, value ) -> (key |> InterpolatedField.interpolate variables |> String.toLower) /= "content-type")
            |> List.map
                (\( key, value ) ->
                    Http.header
                        (InterpolatedField.interpolate variables key)
                        (InterpolatedField.interpolate variables value)
                )
    , body =
        case request.body of
            Fusion.Types.StringBody mime body ->
                Fusion.Types.StringBody mime body

            Fusion.Types.Empty ->
                Fusion.Types.Empty

            Fusion.Types.JsonBody body ->
                Fusion.Types.StringBody "application/json" body
    , url = request.url |> InterpolatedField.interpolate variables
    , method =
        case request.method of
            GET ->
                Fusion.Types.GET

            POST ->
                Fusion.Types.POST
    , timeout = request.timeout
    }


methodToString : Method -> String
methodToString method =
    case method of
        GET ->
            "GET"

        POST ->
            "POST"


referencedVariables : Request -> List InterpolatedField.Variable
referencedVariables request =
    request.headers
        |> List.concatMap
            (\( key, value ) ->
                InterpolatedField.referencedVariables key ++ InterpolatedField.referencedVariables value
            )
        |> List.append (InterpolatedField.referencedVariables request.url)
        |> List.append (request.auth |> Maybe.map authReferencedVariables |> Maybe.withDefault [])


authReferencedVariables : Auth -> List InterpolatedField.Variable
authReferencedVariables auth =
    case auth of
        BasicAuth basic ->
            InterpolatedField.referencedVariables basic.username ++ InterpolatedField.referencedVariables basic.password
