module Elm.Gen.OptimizedDecoder exposing (andMap, andThen, array, at, bool, decodeString, decodeValue, decoder, dict, errorToString, fail, field, float, fromResult, id_, index, int, keyValuePairs, lazy, list, make_, map, map2, map3, map4, map5, map6, map7, map8, maybe, moduleName_, null, nullable, oneOf, optionalField, string, succeed, types_, value)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "OptimizedDecoder" ]


types_ :
    { value : Type.Annotation
    , decoder : Type.Annotation -> Type.Annotation
    , error : Type.Annotation
    }
types_ =
    { value = Type.named moduleName_ "Value"
    , decoder = \arg0 -> Type.namedWith moduleName_ "Decoder" [ arg0 ]
    , error = Type.named moduleName_ "Error"
    }


make_ : {}
make_ =
    {}


{-| A simple wrapper for `Json.Decode.errorToString`.
-}
errorToString : Elm.Expression -> Elm.Expression
errorToString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "errorToString"
            (Type.function
                [ Type.namedWith [ "Json", "Decode" ] "Error" [] ]
                Type.string
            )
        )
        [ arg1 ]


{-| Decode a string.

    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ "hello world" """
        |> decodeString string
    --> Success "hello world"


    """ 123 """
        |> decodeString string
    --> Errors (Nonempty (Here <| Expected TString (Encode.int 123)) [])

-}
string : Elm.Expression
string =
    Elm.valueWith
        moduleName_
        "string"
        (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.string ])


{-| Decode a boolean value.

    """ [ true, false ] """
        |> decodeString (list bool)
    --> Success [ True, False ]

-}
bool : Elm.Expression
bool =
    Elm.valueWith
        moduleName_
        "bool"
        (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.bool ])


{-| Decode a number into an `Int`.

    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ 123 """
        |> decodeString int
    --> Success 123


    """ 0.1 """
        |> decodeString int
    --> Errors <|
    -->   Nonempty
    -->     (Here <| Expected TInt (Encode.float 0.1))
    -->     []

-}
int : Elm.Expression
int =
    Elm.valueWith
        moduleName_
        "int"
        (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.int ])


{-| Decode a number into a `Float`.

    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ 12.34 """
        |> decodeString float
    --> Success 12.34


    """ 12 """
        |> decodeString float
    --> Success 12


    """ null """
        |> decodeString float
    --> Errors (Nonempty (Here <| Expected TNumber Encode.null) [])

-}
float : Elm.Expression
float =
    Elm.valueWith
        moduleName_
        "float"
        (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.float ])


{-| Decodes successfully and wraps with a `Just`. If the values is `null`
succeeds with `Nothing`.

    """ [ { "foo": "bar" }, { "foo": null } ] """
        |> decodeString (list <| field "foo" <| nullable string)
    --> Success [ Just "bar", Nothing ]

-}
nullable : Elm.Expression -> Elm.Expression
nullable arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "nullable"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.maybe (Type.var "a") ]
                )
            )
        )
        [ arg1 ]


{-| Decode a list of values, decoding each entry with the provided decoder.

    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ [ "foo", "bar" ] """
        |> decodeString (list string)
    --> Success [ "foo", "bar" ]


    """ [ "foo", null ] """
        |> decodeString (list string)
    --> Errors <|
    -->   Nonempty
    -->     (AtIndex 1 <|
    -->       Nonempty (Here <| Expected TString Encode.null) []
    -->     )
    -->     []

-}
list : Elm.Expression -> Elm.Expression
list arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.list (Type.var "a") ]
                )
            )
        )
        [ arg1 ]


{-| _Convenience function._ Decode a JSON array into an Elm `Array`.

    import Array

    """ [ 1, 2, 3 ] """
        |> decodeString (array int)
    --> Success <| Array.fromList [ 1, 2, 3 ]

-}
array : Elm.Expression -> Elm.Expression
array arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "array"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.namedWith [ "Array" ] "Array" [ Type.var "a" ] ]
                )
            )
        )
        [ arg1 ]


{-| _Convenience function._ Decode a JSON object into an Elm `Dict String`.

    import Dict


    """ { "foo": "bar", "bar": "hi there" } """
        |> decodeString (dict string)
    --> Success <| Dict.fromList
    -->   [ ( "bar", "hi there" )
    -->   , ( "foo", "bar" )
    -->   ]

-}
dict : Elm.Expression -> Elm.Expression
dict arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "dict"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "v" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.namedWith
                        [ "Dict" ]
                        "Dict"
                        [ Type.string, Type.var "v" ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Decode a JSON object into a list of key-value pairs. The decoder you provide
will be used to decode the values.

    """ { "foo": "bar", "hello": "world" } """
        |> decodeString (keyValuePairs string)
    --> Success [ ( "foo", "bar" ), ( "hello", "world" ) ]

-}
keyValuePairs : Elm.Expression -> Elm.Expression
keyValuePairs arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "keyValuePairs"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.list (Type.tuple Type.string (Type.var "a")) ]
                )
            )
        )
        [ arg1 ]


{-| Decode the content of a field using a provided decoder.

    import List.Nonempty as Nonempty
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode

    """ { "foo": "bar" } """
        |> decodeString (field "foo" string)
    --> Success "bar"


    """ [ { "foo": "bar" }, { "foo": "baz", "hello": "world" } ] """
        |> decodeString (list (field "foo" string))
    --> WithWarnings expectedWarnings [ "bar", "baz" ]


    expectedWarnings : Warnings
    expectedWarnings =
        UnusedField "hello"
            |> Here
            |> Nonempty.fromElement
            |> AtIndex 1
            |> Nonempty.fromElement

-}
field : Elm.Expression -> Elm.Expression -> Elm.Expression
field arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "field"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Decodes a value at a certain path, using a provided decoder. Essentially,
writing `at [ "a", "b", "c" ]  string` is sugar over writing
`field "a" (field "b" (field "c" string))`}.

    """ { "a": { "b": { "c": "hi there" } } } """
        |> decodeString (at [ "a", "b", "c" ] string)
    --> Success "hi there"

-}
at : List Elm.Expression -> Elm.Expression -> Elm.Expression
at arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "at"
            (Type.function
                [ Type.list Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ Elm.list arg1, arg2 ]


{-| Decode a specific index using a specified `Decoder`.

    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ [ "hello", 123 ] """
        |> decodeString (map2 Tuple.pair (index 0 string) (index 1 int))
    --> Success ( "hello", 123 )


    """ [ "hello", "there" ] """
        |> decodeString (index 1 string)
    --> WithWarnings (Nonempty (AtIndex 0 (Nonempty (Here (UnusedValue (Encode.string "hello"))) [])) [])
    -->   "there"

-}
index : Elm.Expression -> Elm.Expression -> Elm.Expression
index arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "index"
            (Type.function
                [ Type.int
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| If a field is missing, succeed with `Nothing`. If it is present, decode it
as normal and wrap successes in a `Just`.

When decoding with
[`maybe`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#maybe),
if a field is present but malformed, you get a success and Nothing.
`optionalField` gives you a failed decoding in that case, so you know
you received malformed data.

Examples:

    import Json.Decode exposing (..)
    import Json.Encode

Let's define a `stuffDecoder` that extracts the `"stuff"` field, if it exists.

    stuffDecoder : Decoder (Maybe String)
    stuffDecoder =
        optionalField "stuff" string

If the "stuff" field is missing, decode to Nothing.

    """ { } """
        |> decodeString stuffDecoder
    --> Ok Nothing

If the "stuff" field is present but not a String, fail decoding.

    expectedError : Error
    expectedError =
        Failure "Expecting a STRING" (Json.Encode.list identity [])
          |> Field "stuff"

    """ { "stuff": [] } """
        |> decodeString stuffDecoder
    --> Err expectedError

If the "stuff" field is present and valid, decode to Just String.

    """ { "stuff": "yay!" } """
        |> decodeString stuffDecoder
    --> Ok <| Just "yay!"

Definition from the json-extra package: <https://github.com/elm-community/json-extra>.

-}
optionalField : Elm.Expression -> Elm.Expression -> Elm.Expression
optionalField arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "optionalField"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.maybe (Type.var "a") ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Decodes successfully and wraps with a `Just`, handling failure by succeeding
with `Nothing`.

    import List.Nonempty as Nonempty
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ [ "foo", 12 ] """
        |> decodeString (list <| maybe string)
    --> WithWarnings expectedWarnings [ Just "foo", Nothing ]


    expectedWarnings : Warnings
    expectedWarnings =
        UnusedValue (Encode.int 12)
            |> Here
            |> Nonempty.fromElement
            |> AtIndex 1
            |> Nonempty.fromElement

-}
maybe : Elm.Expression -> Elm.Expression
maybe arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "maybe"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.maybe (Type.var "a") ]
                )
            )
        )
        [ arg1 ]


{-| Tries a bunch of decoders. The first one to not fail will be the one used.

If all fail, the errors are collected into a `BadOneOf`.

    import List.Nonempty as Nonempty
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode

    """ [ 12, "whatever" ] """
        |> decodeString (list <| oneOf [ map String.fromInt int, string ])
    --> Success [ "12", "whatever" ]


    """ null """
        |> decodeString (oneOf [ string, map String.fromInt int ])
    --> Errors <| Nonempty.fromElement <| Here <| BadOneOf
    -->   [ Nonempty.fromElement <| Here <| Expected TString Encode.null
    -->   , Nonempty.fromElement <| Here <| Expected TInt Encode.null
    -->   ]

-}
oneOf : List Elm.Expression -> Elm.Expression
oneOf arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ Elm.list arg1 ]


{-| Required when using (mutually) recursive decoders.
-}
lazy : (Elm.Expression -> Elm.Expression) -> Elm.Expression
lazy arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "lazy"
            (Type.function
                [ Type.function
                    [ Type.unit ]
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 Elm.pass ]


{-| Extract a piece without actually decoding it.

If a structure is decoded as a `value`, everything _in_ the structure will be
considered as having been used and will not appear in `UnusedValue` warnings.

    import Json.Encode as Encode


    """ [ 123, "world" ] """
        |> decodeString value
    --> Success (Encode.list identity [ Encode.int 123, Encode.string "world" ])

-}
value : Elm.Expression
value =
    Elm.valueWith
        moduleName_
        "value"
        (Type.namedWith
            [ "OptimizedDecoder" ]
            "Decoder"
            [ Type.namedWith [ "OptimizedDecoder" ] "Value" [] ]
        )


{-| Decode a `null` and succeed with some value.

    """ null """
        |> decodeString (null "it was null")
    --> Success "it was null"

Note that `undefined` and `null` are not the same thing. This cannot be used to
verify that a field is _missing_, only that it is explicitly set to `null`.

    """ { "foo": null } """
        |> decodeString (field "foo" (null ()))
    --> Success ()


    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ { } """
        |> decodeString (field "foo" (null ()))
    --> Errors <|
    -->   Nonempty
    -->     (Here <| Expected (TObjectField "foo") (Encode.object []))
    -->     []

-}
null : Elm.Expression -> Elm.Expression
null arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "null"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| A decoder that will ignore the actual JSON and succeed with the provided
value. Note that this may still fail when dealing with an invalid JSON string.

If a value in the JSON ends up being ignored because of this, this will cause a
warning.

    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode


    """ null """
        |> decodeString (value |> andThen (\_ -> succeed "hello world"))
    --> Success "hello world"


    """ null """
        |> decodeString (succeed "hello world")
    --> WithWarnings
    -->     (Nonempty (Here <| UnusedValue Encode.null) [])
    -->     "hello world"


    """ foo """
        |> decodeString (succeed "hello world")
    --> BadJson

-}
succeed : Elm.Expression -> Elm.Expression
succeed arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Ignore the json and fail with a provided message.

    import List.Nonempty exposing (Nonempty(..))
    import Json.Decode.Exploration.Located exposing (Located(..))
    import Json.Encode as Encode

    """ "hello" """
        |> decodeString (fail "failure")
    --> Errors (Nonempty (Here <| Failure "failure" (Just <| Encode.string "hello")) [])

-}
fail : Elm.Expression -> Elm.Expression
fail arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Chain decoders where one decoder depends on the value of another decoder.
-}
andThen : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
andThen arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "b" ]
                    )
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Useful for transforming decoders.

    """ "foo" """
        |> decodeString (map String.toUpper string)
    --> Success "FOO"

-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Combine 2 decoders.
-}
map2 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map2 arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "c")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| Combine 3 decoders.
-}
map3 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map3 arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "d")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4 ]


{-| Combine 4 decoders.
-}
map4 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map4 arg1 arg2 arg3 arg4 arg5 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "e")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4, arg5 ]


{-| Combine 5 decoders.
-}
map5 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map5 arg1 arg2 arg3 arg4 arg5 arg6 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "f")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        ]


{-| Combine 6 decoders.
-}
map6 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map6 arg1 arg2 arg3 arg4 arg5 arg6 arg7 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map6"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    ]
                    (Type.var "g")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "g" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        ]


{-| Combine 7 decoders.
-}
map7 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map7 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map7"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    ]
                    (Type.var "h")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "g" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "h" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        , arg8
        ]


{-| Combine 8 decoders.
-}
map8 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map8 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map8"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    , Type.var "h"
                    ]
                    (Type.var "i")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "g" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "h" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "i" ]
                )
            )
        )
        [ arg1
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        , arg8
        , arg9
        ]


{-| Decode an argument and provide it to a function in a decoder.

    decoder : Decoder String
    decoder =
        succeed (String.repeat)
            |> andMap (field "count" int)
            |> andMap (field "val" string)


    """ { "val": "hi", "count": 3 } """
        |> decodeString decoder
    --> Success "hihihi"

-}
andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
andMap arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andMap"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.function [ Type.var "a" ] (Type.var "b") ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Turn a Result into a Decoder (uses succeed and fail under the hood). This is often
helpful for chaining with `andThen`.
-}
fromResult : Elm.Expression -> Elm.Expression
fromResult arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromResult"
            (Type.function
                [ Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.string, Type.var "value" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 ]


{-| A simple wrapper for `Json.Decode.errorToString`.

This will directly call the raw `elm/json` decoder that is stored under the hood.

-}
decodeString : Elm.Expression -> Elm.Expression -> Elm.Expression
decodeString arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decodeString"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.string
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.namedWith [ "OptimizedDecoder" ] "Error" []
                    , Type.var "a"
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| A simple wrapper for `Json.Decode.errorToString`.

This will directly call the raw `elm/json` decoder that is stored under the hood.

-}
decodeValue : Elm.Expression -> Elm.Expression -> Elm.Expression
decodeValue arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decodeValue"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith [ "OptimizedDecoder" ] "Value" []
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.namedWith [ "OptimizedDecoder" ] "Error" []
                    , Type.var "a"
                    ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Usually you'll want to directly pass your `OptimizedDecoder` to `StaticHttp` or other `elm-pages` APIs.
But if you want to re-use your decoder somewhere else, it may be useful to turn it into a plain `elm/json` decoder.
-}
decoder : Elm.Expression -> Elm.Expression
decoder arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decoder"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.var "a" ])
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { errorToString : Elm.Expression
    , string : Elm.Expression
    , bool : Elm.Expression
    , int : Elm.Expression
    , float : Elm.Expression
    , nullable : Elm.Expression
    , list : Elm.Expression
    , array : Elm.Expression
    , dict : Elm.Expression
    , keyValuePairs : Elm.Expression
    , field : Elm.Expression
    , at : Elm.Expression
    , index : Elm.Expression
    , optionalField : Elm.Expression
    , maybe : Elm.Expression
    , oneOf : Elm.Expression
    , lazy : Elm.Expression
    , value : Elm.Expression
    , null : Elm.Expression
    , succeed : Elm.Expression
    , fail : Elm.Expression
    , andThen : Elm.Expression
    , map : Elm.Expression
    , map2 : Elm.Expression
    , map3 : Elm.Expression
    , map4 : Elm.Expression
    , map5 : Elm.Expression
    , map6 : Elm.Expression
    , map7 : Elm.Expression
    , map8 : Elm.Expression
    , andMap : Elm.Expression
    , fromResult : Elm.Expression
    , decodeString : Elm.Expression
    , decodeValue : Elm.Expression
    , decoder : Elm.Expression
    }
id_ =
    { errorToString =
        Elm.valueWith
            moduleName_
            "errorToString"
            (Type.function
                [ Type.namedWith [ "Json", "Decode" ] "Error" [] ]
                Type.string
            )
    , string =
        Elm.valueWith
            moduleName_
            "string"
            (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.string ])
    , bool =
        Elm.valueWith
            moduleName_
            "bool"
            (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.bool ])
    , int =
        Elm.valueWith
            moduleName_
            "int"
            (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.int ])
    , float =
        Elm.valueWith
            moduleName_
            "float"
            (Type.namedWith [ "OptimizedDecoder" ] "Decoder" [ Type.float ])
    , nullable =
        Elm.valueWith
            moduleName_
            "nullable"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.maybe (Type.var "a") ]
                )
            )
    , list =
        Elm.valueWith
            moduleName_
            "list"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.list (Type.var "a") ]
                )
            )
    , array =
        Elm.valueWith
            moduleName_
            "array"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.namedWith [ "Array" ] "Array" [ Type.var "a" ] ]
                )
            )
    , dict =
        Elm.valueWith
            moduleName_
            "dict"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "v" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.namedWith
                        [ "Dict" ]
                        "Dict"
                        [ Type.string, Type.var "v" ]
                    ]
                )
            )
    , keyValuePairs =
        Elm.valueWith
            moduleName_
            "keyValuePairs"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.list (Type.tuple Type.string (Type.var "a")) ]
                )
            )
    , field =
        Elm.valueWith
            moduleName_
            "field"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , at =
        Elm.valueWith
            moduleName_
            "at"
            (Type.function
                [ Type.list Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , index =
        Elm.valueWith
            moduleName_
            "index"
            (Type.function
                [ Type.int
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , optionalField =
        Elm.valueWith
            moduleName_
            "optionalField"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.maybe (Type.var "a") ]
                )
            )
    , maybe =
        Elm.valueWith
            moduleName_
            "maybe"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.maybe (Type.var "a") ]
                )
            )
    , oneOf =
        Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , lazy =
        Elm.valueWith
            moduleName_
            "lazy"
            (Type.function
                [ Type.function
                    [ Type.unit ]
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , value =
        Elm.valueWith
            moduleName_
            "value"
            (Type.namedWith
                [ "OptimizedDecoder" ]
                "Decoder"
                [ Type.namedWith [ "OptimizedDecoder" ] "Value" [] ]
            )
    , null =
        Elm.valueWith
            moduleName_
            "null"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , fail =
        Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , andThen =
        Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "b" ]
                    )
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "c")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                )
            )
    , map3 =
        Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "d")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                )
            )
    , map4 =
        Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "e")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                )
            )
    , map5 =
        Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "f")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                )
            )
    , map6 =
        Elm.valueWith
            moduleName_
            "map6"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    ]
                    (Type.var "g")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "g" ]
                )
            )
    , map7 =
        Elm.valueWith
            moduleName_
            "map7"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    ]
                    (Type.var "h")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "g" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "h" ]
                )
            )
    , map8 =
        Elm.valueWith
            moduleName_
            "map8"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    , Type.var "f"
                    , Type.var "g"
                    , Type.var "h"
                    ]
                    (Type.var "i")
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "c" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "d" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "e" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "f" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "g" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "h" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "i" ]
                )
            )
    , andMap =
        Elm.valueWith
            moduleName_
            "andMap"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.function [ Type.var "a" ] (Type.var "b") ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                )
            )
    , fromResult =
        Elm.valueWith
            moduleName_
            "fromResult"
            (Type.function
                [ Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.string, Type.var "value" ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "value" ]
                )
            )
    , decodeString =
        Elm.valueWith
            moduleName_
            "decodeString"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.string
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.namedWith [ "OptimizedDecoder" ] "Error" []
                    , Type.var "a"
                    ]
                )
            )
    , decodeValue =
        Elm.valueWith
            moduleName_
            "decodeValue"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.namedWith [ "OptimizedDecoder" ] "Value" []
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.namedWith [ "OptimizedDecoder" ] "Error" []
                    , Type.var "a"
                    ]
                )
            )
    , decoder =
        Elm.valueWith
            moduleName_
            "decoder"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.var "a" ])
            )
    }


