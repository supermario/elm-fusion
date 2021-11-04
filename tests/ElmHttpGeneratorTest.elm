module ElmHttpGeneratorTest exposing (suite)

import Elm
import ElmHttpGenerator
import Expect
import InterpolatedField
import Request exposing (Request)
import Test exposing (Test, describe, test)


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
                }
                    |> toRequest
                    |> ElmHttpGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """request toMsg =
    Http.get
        { url = "https://example.com", expect = Http.expectJson toMsg decoder }"""
        , test "GET with headers" <|
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
                    |> ElmHttpGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """request toMsg =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "accept-language" "en-US,en;q=0.9"
            , Http.header "Referer" "http://www.wikipedia.org/"
            ]
        , url = "https://example.com"
        , body = Http.emptyBody
        , expect = Http.expectJson toMsg decoder
        , timeout = Nothing
        , tracker = Nothing
        }"""
        , test "GET with parameters" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    [ ( "accept-language", "${PREFERRED_LANGUAGE};q=0.9" )
                    , ( "Referer", "http://www.wikipedia.org/" )
                    ]
                }
                    |> toRequest
                    |> ElmHttpGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """request toMsg preferredLanguage =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "accept-language" (preferredLanguage ++ ";q=0.9")
            , Http.header "Referer" "http://www.wikipedia.org/"
            ]
        , url = "https://example.com"
        , body = Http.emptyBody
        , expect = Http.expectJson toMsg decoder
        , timeout = Nothing
        , tracker = Nothing
        }"""
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
