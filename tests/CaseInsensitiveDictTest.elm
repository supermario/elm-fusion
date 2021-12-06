module CaseInsensitiveDictTest exposing (..)

import Dict exposing (Dict)
import Dict.CaseInsensitive
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "CaseInsensitive.Dict"
        [ test "empty" <|
            \() ->
                Dict.CaseInsensitive.empty
                    |> Dict.CaseInsensitive.toDict
                    |> Expect.equal Dict.empty
        , test "insert key twice with different casing" <|
            \() ->
                Dict.CaseInsensitive.empty
                    |> Dict.CaseInsensitive.insert "abc" 1
                    |> Dict.CaseInsensitive.insert "ABC" 2
                    |> Dict.CaseInsensitive.toDict
                    |> Expect.equal
                        (Dict.empty
                            |> Dict.insert "ABC" 1
                            |> Dict.insert "ABC" 2
                        )
        , test "get with different casing than insert" <|
            \() ->
                Dict.CaseInsensitive.empty
                    |> Dict.CaseInsensitive.insert "ABC" 1
                    |> Dict.CaseInsensitive.get "abc"
                    |> Expect.equal (Just 1)
        ]
