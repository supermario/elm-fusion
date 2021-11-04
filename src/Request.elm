module Request exposing (Body(..), Method(..), Request, convert, methodToString, referencedVariables)

import Dict exposing (Dict)
import Fusion.Types
import Http
import InterpolatedField exposing (InterpolatedField)


type alias Request =
    { method : Method
    , headers : List ( InterpolatedField, InterpolatedField )
    , url : InterpolatedField
    , body : Body
    , timeout : Maybe Float

    --, auth : Maybe Auth
    }


type Auth
    = BasicAuth
        { username : String
        , password : String
        }


type Method
    = GET
    | POST


type Body
    = Empty
    | StringBody String String


convert : Dict String String -> Request -> Fusion.Types.Request
convert variables request =
    { headers =
        request.headers
            |> List.map
                (\( key, value ) ->
                    Http.header
                        (InterpolatedField.interpolate variables key)
                        (InterpolatedField.interpolate variables value)
                )
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
