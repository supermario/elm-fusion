module CurlTest exposing (..)

import Cli.OptionsParser.MatchResult exposing (MatchResult(..))
import Curl exposing (runCurl)
import Dict
import Expect exposing (Expectation)
import InterpolatedField
import Request exposing (Request)
import Test exposing (..)


expectRequest :
    { headers : List ( String, String )
    , method : Request.Method
    , url : String
    , body : Request.Body
    , auth : Maybe Request.Auth
    }
    -> MatchResult Request
    -> Expectation
expectRequest expected actual =
    actual
        |> Expect.equal
            (Match
                (Ok
                    { url = expected.url |> InterpolatedField.fromString
                    , method = expected.method
                    , headers =
                        expected.headers
                            |> Dict.fromList
                            |> Dict.toList
                            |> List.map (Tuple.mapFirst InterpolatedField.fromString >> Tuple.mapSecond InterpolatedField.fromString)
                    , timeout = Nothing
                    , body = expected.body
                    , auth = expected.auth
                    }
                )
            )


suite : Test
suite =
    describe "curl"
        [ test "get" <|
            \() ->
                runCurl """'http://en.wikipedia.org/' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://www.wikipedia.org/'  -H 'Connection: keep-alive' --compressed"""
                    |> expectRequest
                        { url = "http://en.wikipedia.org/"
                        , method = Request.GET
                        , headers =
                            [ ( "Accept-Encoding", "gzip, deflate, sdch" )
                            , ( "Accept-Language", "en-US,en;q=0.8" )
                            , ( "User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" )
                            , ( "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" )
                            , ( "Referer", "http://www.wikipedia.org/" )
                            , ( "Connection", "keep-alive" )
                            ]
                        , body = Request.Empty
                        , auth = Nothing
                        }
        , test "post" <|
            \() ->
                """'http://fiddle.jshell.net/echo/html/' -H 'Origin: http://fiddle.jshell.net' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Referer: http://fiddle.jshell.net/_display/' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data 'msg1=wow&msg2=such&msg3=data' --compressed"""
                    |> runCurl
                    |> expectRequest
                        { url = "http://fiddle.jshell.net/echo/html/"
                        , method = Request.POST
                        , headers =
                            [ ( "Origin", "http://fiddle.jshell.net" )
                            , ( "Accept-Encoding", "gzip, deflate" )
                            , ( "Accept-Language", "en-US,en;q=0.8" )
                            , ( "User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36" )
                            , ( "Content-Type", "application/x-www-form-urlencoded; charset=UTF-8" )
                            , ( "Accept", "*/*" )
                            , ( "Referer", "http://fiddle.jshell.net/_display/" )
                            , ( "X-Requested-With", "XMLHttpRequest" )
                            , ( "Connection", "keep-alive" )
                            ]
                        , body = Request.StringBody "application/x-www-form-urlencoded; charset=UTF-8" "msg1=wow&msg2=such&msg3=data"
                        , auth = Nothing
                        }
        , test "example from chrome dev tools copy" <|
            \() ->
                """'https://incrementalelm.com/manifest.json' \\
                     -H 'authority: incrementalelm.com' \\
                     -H 'pragma: no-cache' \\
                     -H 'cache-control: no-cache' \\
                     -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36' \\
                     -H 'accept: */*' \\
                     -H 'sec-gpc: 1' \\
                     -H 'sec-fetch-site: same-origin' \\
                     -H 'sec-fetch-mode: cors' \\
                     -H 'sec-fetch-dest: manifest' \\
                     -H 'referer: https://incrementalelm.com/' \\
                     -H 'accept-language: en-US,en;q=0.9' \\
                     --compressed"""
                    |> runCurl
                    |> expectRequest
                        { url = "https://incrementalelm.com/manifest.json"
                        , method = Request.GET
                        , headers =
                            [ ( "accept", "*/*" )
                            , ( "accept-language", "en-US,en;q=0.9" )
                            , ( "authority", "incrementalelm.com" )
                            , ( "cache-control", "no-cache" )
                            , ( "pragma", "no-cache" )
                            , ( "referer", "https://incrementalelm.com/" )
                            , ( "sec-fetch-dest", "manifest" )
                            , ( "sec-fetch-mode", "cors" )
                            , ( "sec-fetch-site", "same-origin" )
                            , ( "sec-gpc", "1" )
                            , ( "user-agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36" )
                            ]
                        , body = Request.Empty
                        , auth = Nothing
                        }
        , test "JSON body" <|
            \() ->
                """'http://fiddle.jshell.net/echo/html/' -H 'Content-Type: application/json' --data '{"json": "data"}'"""
                    |> runCurl
                    |> expectRequest
                        { url = "http://fiddle.jshell.net/echo/html/"
                        , method = Request.POST
                        , headers =
                            [ ( "Content-Type", "application/json" )
                            ]
                        , body = Request.StringBody "application/json" """{"json": "data"}"""
                        , auth = Nothing
                        }
        , test "parses basic auth option from -u flag" <|
            \() ->
                """https://api.mux.com/video/v1/assets/${ASSET_ID} \\
                     -X GET \\
                     -H 'Content-Type: application/json' \\
                     -u ${MUX_TOKEN_ID}:${MUX_TOKEN_SECRET}"""
                    |> runCurl
                    |> expectRequest
                        { url = "https://api.mux.com/video/v1/assets/${ASSET_ID}"
                        , method = Request.GET
                        , headers =
                            [ ( "Content-Type", "application/json" )
                            ]
                        , body = Request.Empty
                        , auth =
                            Request.BasicAuth
                                { username = "${MUX_TOKEN_ID}" |> InterpolatedField.fromString
                                , password = "${MUX_TOKEN_SECRET}" |> InterpolatedField.fromString
                                }
                                |> Just
                        }
        ]
