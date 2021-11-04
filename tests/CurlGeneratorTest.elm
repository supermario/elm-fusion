module CurlGeneratorTest exposing (..)

import CurlGenerator
import Expect
import InterpolatedField
import Request exposing (Request)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "CurlGenerator"
        [ test "simple GET" <|
            \() ->
                { url = "http://en.wikipedia.org/"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    [ ( "Accept-Language", "en-US,en;q=0.8" )
                    , ( "Referer", "http://www.wikipedia.org/" )
                    ]
                , auth = Nothing
                }
                    |> toRequest
                    |> CurlGenerator.generate
                    |> Expect.equal
                        """curl "http://en.wikipedia.org/" -H "Accept-Language: en-US,en;q=0.8" -H "Referer: http://www.wikipedia.org/\""""
        , test "Basic Auth" <|
            \() ->
                { url = "http://en.wikipedia.org/"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    [ ( "Accept-Language", "en-US,en;q=0.8" )
                    , ( "Referer", "http://www.wikipedia.org/" )
                    ]
                , auth =
                    Just
                        (Request.BasicAuth
                            { username = "user" |> InterpolatedField.fromString
                            , password = "$PASSWORD" |> InterpolatedField.fromString
                            }
                        )
                }
                    |> toRequest
                    |> CurlGenerator.generate
                    |> Expect.equal
                        """curl "http://en.wikipedia.org/" -H "Accept-Language: en-US,en;q=0.8" -H "Referer: http://www.wikipedia.org/" -u "user:$PASSWORD\""""
        ]


toRequest :
    { url : String
    , method : Request.Method
    , body : Request.Body
    , headers : List ( String, String )
    , auth : Maybe Request.Auth
    }
    -> Request
toRequest request =
    { url = request.url |> InterpolatedField.fromString
    , method = request.method
    , body = request.body
    , headers =
        request.headers
            |> List.map
                (\( key, value ) ->
                    ( InterpolatedField.fromString key
                    , InterpolatedField.fromString value
                    )
                )
    , timeout = Nothing
    , auth = request.auth
    }
