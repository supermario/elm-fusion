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
                , headers = []
                , auth = Nothing
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
                , auth = Nothing
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
                , auth = Nothing
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
        , test "with Basic Auth" <|
            \() ->
                { url = "https://api.mux.com/video/v1/assets/${ASSET_ID}"
                , method = Request.GET
                , body = Request.Empty
                , headers =
                    [ ( "Content-Type", "application/json" )
                    ]
                , auth =
                    Request.BasicAuth
                        { username = "${MUX_TOKEN_ID}" |> InterpolatedField.fromString
                        , password = "${MUX_TOKEN_SECRET}" |> InterpolatedField.fromString
                        }
                        |> Just
                }
                    |> toRequest
                    |> ElmHttpGenerator.generate
                    |> Elm.declarationToString
                    |> Expect.equal
                        """request toMsg muxTokenId muxTokenSecret assetId =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header
                "Authorization"
                (Base64.encode (muxTokenId ++ ":" ++ muxTokenSecret))
            , Http.header "Content-Type" "application/json"
            ]
        , url = "https://api.mux.com/video/v1/assets/" ++ assetId
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
