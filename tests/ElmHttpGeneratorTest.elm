module ElmHttpGeneratorTest exposing (suite)

import ElmHttpGenerator
import Expect
import Request
import Test exposing (Test, describe, only, test)


suite : Test
suite =
    describe "ElmHttpGenerator"
        [ test "simple GET" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    []
                , timeout = Nothing
                }
                    |> ElmHttpGenerator.generate
                    |> Expect.equal
                        """
request toMsg =
    Http.get
        { url = "https://example.com"
        , expect = Http.expectString toMsg
        }
"""
        , test "GET with headers" <|
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
                    |> ElmHttpGenerator.generate
                    |> Expect.equal
                        """
request toMsg =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "accept-language" "en-US,en;q=0.9"
            , Http.header "Referer" "http://www.wikipedia.org/"
            ]
        , url = "https://example.com"
        , body = Http.emptyBody
        , expect = Http.expectString toMsg
        , timeout = Nothing
        , tracker = Nothing
        }
"""
        ]
