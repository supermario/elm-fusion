module DataSourceGeneratorTest exposing (..)

import DataSourceGenerator
import Dict
import Elm
import Expect
import InterpolatedField
import Request exposing (Request)
import Test exposing (Test, describe, test)
import VariableDefinition exposing (VariableDefinition(..))


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
                , auth = Nothing
                }
                    |> toRequest
                    |> DataSourceGenerator.generate Dict.empty
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
                , auth = Nothing
                }
                    |> toRequest
                    |> DataSourceGenerator.generate Dict.empty
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
                , auth = Nothing
                }
                    |> toRequest
                    |> DataSourceGenerator.generate Dict.empty
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
                , auth = Nothing
                }
                    |> toRequest
                    |> DataSourceGenerator.generate Dict.empty
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
                    |> DataSourceGenerator.generate Dict.empty
                    |> Elm.declarationToString
                    |> Expect.equal
                        """data =
    DataSource.Http.request
        (Pages.Secrets.succeed
            (\\muxTokenId muxTokenSecret assetId ->
                { url = "https://api.mux.com/video/v1/assets/" ++ assetId
                , method = "GET"
                , headers =
                    [ ( "Authorization"
                      , Base64.encode (muxTokenId ++ ":" ++ muxTokenSecret)
                      )
                    , ( "Content-Type", "application/json" )
                    ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "MUX_TOKEN_ID"
            |> Secrets.with "MUX_TOKEN_SECRET"
            |> Secrets.with "ASSET_ID"
        )
        decoder"""
        , test "with some params" <|
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
                    |> DataSourceGenerator.generate
                        (Dict.fromList
                            [ ( "ASSET_ID", VariableDefinition "" VariableDefinition.Parameter )
                            ]
                        )
                    |> Elm.declarationToString
                    |> Expect.equal
                        """data assetId =
    DataSource.Http.request
        (Pages.Secrets.succeed
            (\\muxTokenId muxTokenSecret ->
                { url = "https://api.mux.com/video/v1/assets/" ++ assetId
                , method = "GET"
                , headers =
                    [ ( "Authorization"
                      , Base64.encode (muxTokenId ++ ":" ++ muxTokenSecret)
                      )
                    , ( "Content-Type", "application/json" )
                    ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "MUX_TOKEN_ID"
            |> Secrets.with "MUX_TOKEN_SECRET"
        )
        decoder"""
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
