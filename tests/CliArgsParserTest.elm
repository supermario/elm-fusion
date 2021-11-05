module CliArgsParserTest exposing (suite)

import CliArgsParser
import Expect
import Parser
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "CliArgs"
        [ test "double quoted string" <|
            \() ->
                """curl "Hello, World!\""""
                    |> Parser.run CliArgsParser.parser
                    |> Expect.equal
                        (Ok
                            [ "curl"
                            , "Hello, World!"
                            ]
                        )
        , test "single quoted string" <|
            \() ->
                "curl 'Hello, World!'"
                    |> Parser.run CliArgsParser.parser
                    |> Expect.equal
                        (Ok
                            [ "curl"
                            , "Hello, World!"
                            ]
                        )
        , test "escaped newlines" <|
            \() ->
                "echo \\\nHello!"
                    |> Parser.run CliArgsParser.parser
                    |> Expect.equal
                        (Ok
                            [ "echo"
                            , "Hello!"
                            ]
                        )
        ]
