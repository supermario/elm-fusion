module Request exposing (Body(..), Method(..), Request, convert, methodToString)

import Dict
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


convert : Request -> Fusion.Types.Request
convert request =
    { headers =
        request.headers
            |> List.map
                (\( key, value ) ->
                    Http.header
                        (InterpolatedField.interpolate Dict.empty key)
                        (InterpolatedField.interpolate Dict.empty value)
                )
    , body = Fusion.Types.Empty
    , url = request.url |> InterpolatedField.interpolate Dict.empty
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
