module Request exposing (Body(..), Method(..), Request, convert, methodToString)

import Fusion.Types
import Http


type alias Request =
    { method : Method
    , headers : List ( String, String )
    , url : String
    , body : Body
    , timeout : Maybe Float
    }


type Method
    = GET
    | POST


type Body
    = Empty
    | StringBody String String


convert : Request -> Fusion.Types.Request
convert request =
    { headers = request.headers |> List.map (\( key, value ) -> Http.header key value)
    , body = Fusion.Types.Empty
    , url = request.url
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
