module InterpolatedFieldTest exposing (..)

import Elm
import Expect
import InterpolatedField
import Parser exposing ((|.), (|=), Parser)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "InterpolatedFieldTest"
        [ describe "token parser"
            [ test "simple interpolation" <|
                \() ->
                    "$NAME"
                        |> Parser.run InterpolatedField.tokenParser
                        |> Expect.equal (Ok (InterpolatedField.Variable "NAME"))
            , test "interpolation with curly" <|
                \() ->
                    "${NAME}"
                        |> Parser.run InterpolatedField.tokenParser
                        |> Expect.equal (Ok (InterpolatedField.Variable "NAME"))
            ]
        , describe "fields"
            [ test "interpolation with curly" <|
                \() ->
                    "Hello ${NAME}!"
                        |> Parser.run InterpolatedField.fieldParser
                        |> Expect.equal
                            (Ok
                                [ InterpolatedField.RawText "Hello "
                                , InterpolatedField.InterpolatedText (InterpolatedField.Variable "NAME")
                                , InterpolatedField.RawText "!"
                                ]
                            )
            , test "interpolation without curly" <|
                \() ->
                    "Hello $NAME!"
                        |> Parser.run InterpolatedField.fieldParser
                        |> Expect.equal
                            (Ok
                                [ InterpolatedField.RawText "Hello "
                                , InterpolatedField.InterpolatedText (InterpolatedField.Variable "NAME")
                                , InterpolatedField.RawText "!"
                                ]
                            )
            ]
        , describe "codegen"
            [ test "interpolation with curly" <|
                \() ->
                    "Hello ${NAME}!"
                        |> InterpolatedField.fromString
                        |> InterpolatedField.toElmExpression
                        |> Elm.toString
                        |> Expect.equal
                            """"Hello " ++ name ++ "!\""""
            ]
        ]



{-
   - End parsing before end of string
      - Whitespace
      - Non-identifier character (a-zA-Z or _)
   - Curly interpolation
   - Backslash escaping (maybe don't support?)
-}
