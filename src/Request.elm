module Request exposing (Auth(..), Body(..), Method(..), Request, convert, methodToString, referencedVariables)

import Base64
import Dict exposing (Dict)
import Fusion.Types
import Http
import InterpolatedField exposing (InterpolatedField)
import VariableDefinition exposing (VariableDefinition)


type alias Request =
    { method : Method
    , headers : List ( InterpolatedField, InterpolatedField )
    , url : InterpolatedField
    , body : Body
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


type Body
    = Empty
    | StringBody String String


convert : Dict String VariableDefinition -> Request -> Fusion.Types.Request
convert variables request =
    let
        authHeaders : List Http.Header
        authHeaders =
            case request.auth of
                Just (BasicAuth basicAuth) ->
                    [ Http.header
                        "Authorization"
                        (("Basic "
                            ++ Base64.encode (InterpolatedField.interpolate variables basicAuth.username ++ ":" ++ InterpolatedField.interpolate variables basicAuth.password)
                         )
                            |> Debug.log "Authorization header"
                        )
                    ]

                _ ->
                    []
    in
    { headers =
        request.headers
            |> List.map
                (\( key, value ) ->
                    Http.header
                        (InterpolatedField.interpolate variables key)
                        (InterpolatedField.interpolate variables value)
                )
            |> List.append authHeaders
    , body = Fusion.Types.Empty
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
