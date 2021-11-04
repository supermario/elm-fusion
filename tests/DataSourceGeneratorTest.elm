module DataSourceGeneratorTest exposing (..)

import DataSourceGenerator
import Elm
import Expect
import InterpolatedField
import Request exposing (Request)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "DataSourceGenerator"
        [ test "simple GET" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    [ ( "accept-language", "en-US,en;q=0.9" )
                    , ( "Referer", "http://www.wikipedia.org/" )
                    ]
                }
                    |> toRequest
                    |> DataSourceGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """data =
    DataSource.Http.request
        (Pages.Secrets.succeed
            { url = "https://example.com"
            , method = "GET"
            , headers =
                [ ( "accept-language", "en-US,en;q=0.9" )
                , ( "Referer", "http://www.wikipedia.org/" )
                ]
            , body = DataSource.Http.emptyBody
            }
        )
        decoder"""
        , test "POST with JSON body" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.StringBody "application/json" """{"key":"value"}"""
                , headers =
                    [ ( "accept-language", "en-US,en;q=0.9" )
                    , ( "Referer", "http://www.wikipedia.org/" )
                    ]
                }
                    |> toRequest
                    |> DataSourceGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """data =
    DataSource.Http.request
        (Pages.Secrets.succeed
            { url = "https://example.com"
            , method = "GET"
            , headers =
                [ ( "accept-language", "en-US,en;q=0.9" )
                , ( "Referer", "http://www.wikipedia.org/" )
                ]
            , body =
                DataSource.Http.stringBody
                    "application/json"
                    "{\\"key\\":\\"value\\"}"
            }
        )
        decoder"""
        , test "with Secrets" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    [ ( "accept-language", "en-US,en;q=0.9" )
                    , ( "Authorization", "Basic ${AUTH_TOKEN}" )
                    ]
                }
                    |> toRequest
                    |> DataSourceGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """data =
    DataSource.Http.request
        (Pages.Secrets.succeed
            (\\authToken ->
                { url = "https://example.com"
                , method = "GET"
                , headers =
                    [ ( "accept-language", "en-US,en;q=0.9" )
                    , ( "Authorization", "Basic " ++ authToken )
                    ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "AUTH_TOKEN"
        )
        decoder"""
        , test "with two Secrets" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    [ ( "accept-language", "${PREFERRED_LANGUAGE};q=0.9" )
                    , ( "Authorization", "Basic ${AUTH_TOKEN}" )
                    ]
                }
                    |> toRequest
                    |> DataSourceGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """data =
    DataSource.Http.request
        (Pages.Secrets.succeed
            (\\preferredLanguage authToken ->
                { url = "https://example.com"
                , method = "GET"
                , headers =
                    [ ( "accept-language", preferredLanguage ++ ";q=0.9" )
                    , ( "Authorization", "Basic " ++ authToken )
                    ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "PREFERRED_LANGUAGE"
            |> Secrets.with "AUTH_TOKEN"
        )
        decoder"""
        ]


toRequest :
    { url : String
    , method : Request.Method
    , body : Request.Body
    , headers : List ( String, String )
    }
    -> Request
toRequest request =
    { url = request.url
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
    }
