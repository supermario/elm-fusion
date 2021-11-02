module DataSourceGeneratorTest exposing (..)

import DataSourceGenerator
import Expect
import Request
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
                , timeout = Nothing
                }
                    |> DataSourceGenerator.generate
                    |> Expect.equal
                        """
data =
    DataSource.Http.request
        (Secrets.succeed
            { url = "https://example.com"
            , method = "GET"
            , headers =
                [ ( "accept-language", "en-US,en;q=0.9" )
                , ( "Referer", "http://www.wikipedia.org/" )
                ]
            , body = DataSource.Http.emptyBody
            }
        )
"""
        , test "POST with JSON body" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.StringBody "application/json" """{"key":"value"}"""
                , headers =
                    [ ( "accept-language", "en-US,en;q=0.9" )
                    , ( "Referer", "http://www.wikipedia.org/" )
                    ]
                , timeout = Nothing
                }
                    |> DataSourceGenerator.generate
                    |> Expect.equal
                        """
data =
    DataSource.Http.request
        (Secrets.succeed
            { url = "https://example.com"
            , method = "GET"
            , headers =
                [ ( "accept-language", "en-US,en;q=0.9" )
                , ( "Referer", "http://www.wikipedia.org/" )
                ]
            , body = DataSource.Http.stringBody "application/json" "{\\"key\\":\\"value\\"}"
            }
        )
"""
        ]