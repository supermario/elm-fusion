module Elm.Gen.OptimizedDecoder.Pipeline exposing (custom, decode, hardcoded, id_, make_, moduleName_, optional, optionalAt, required, requiredAt, resolve, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "OptimizedDecoder", "Pipeline" ]


types_ : {}
types_ =
    {}


make_ : {}
make_ =
    {}


{-| Decode a required field.

    import Json.Decode.Exploration exposing (..)

    type alias User =
        { id : Int
        , name : String
        , email : String
        }

    userDecoder : Decoder User
    userDecoder =
        decode User
            |> required "id" int
            |> required "name" string
            |> required "email" string

    """ {"id": 123, "email": "sam@example.com", "name": "Sam"} """
        |> decodeString userDecoder
    --> Success { id = 123, name = "Sam", email = "sam@example.com" }

-}
required : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
required arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "required"
            (Type.function
                [ Type.string
                , Type.namedWith
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
        [ arg1, arg2, arg3 ]


{-| Decode a required nested field.

    import Json.Decode.Exploration exposing (..)

    type alias User =
        { id : Int
        , name : String
        , email : String
        }

    userDecoder : Decoder User
    userDecoder =
        decode User
            |> required "id" int
            |> requiredAt [ "profile", "name" ] string
            |> required "email" string

    """
    {
        "id": 123,
        "email": "sam@example.com",
        "profile": { "name": "Sam" }
    }
    """
        |> decodeString userDecoder
    --> Success { id = 123, name = "Sam", email = "sam@example.com" }

-}
requiredAt :
    List Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
requiredAt arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "requiredAt"
            (Type.function
                [ Type.list Type.string
                , Type.namedWith
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
        [ Elm.list arg1, arg2, arg3 ]


{-| Decode a field that may be missing or have a null value. If the field is
missing, then it decodes as the `fallback` value. If the field is present,
then `valDecoder` is used to decode its value. If `valDecoder` fails on a
`null` value, then the `fallback` is used as if the field were missing
entirely.

    import Json.Decode.Exploration exposing (..)

    type alias User =
        { id : Int
        , name : String
        , email : String
        }

    userDecoder : Decoder User
    userDecoder =
        decode User
            |> required "id" int
            |> optional "name" string "blah"
            |> required "email" string

    """ { "id": 123, "email": "sam@example.com" } """
        |> decodeString userDecoder
    --> Success { id = 123, name = "blah", email = "sam@example.com" }

Because `valDecoder` is given an opportunity to decode `null` values before
resorting to the `fallback`, you can distinguish between missing and `null`
values if you need to:

    userDecoder2 =
        decode User
            |> required "id" int
            |> optional "name" (oneOf [ string, null "NULL" ]) "MISSING"
            |> required "email" string

Note also that this behaves _slightly_ different than the stock pipeline
package.

In the stock pipeline package, running the following decoder with an array as
the input would _succeed_.

    fooDecoder =
        decode identity
            |> optional "foo" (maybe string) Nothing

In this package, such a decoder will error out instead, saying that it expected
the input to be an object. The _key_ `"foo"` is optional, but it really does
have to be an object before we even consider trying your decoder or returning
the fallback.

-}
optional :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
optional arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "optional"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.var "a"
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
        [ arg1, arg2, arg3, arg4 ]


{-| Decode an optional nested field.
-}
optionalAt :
    List Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
optionalAt arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "optionalAt"
            (Type.function
                [ Type.list Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.var "a"
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
        [ Elm.list arg1, arg2, arg3, arg4 ]


{-| Rather than decoding anything, use a fixed value for the next step in the
pipeline. `harcoded` does not look at the JSON at all.

    import Json.Decode.Exploration exposing (..)


    type alias User =
        { id : Int
        , name : String
        , email : String
        }

    userDecoder : Decoder User
    userDecoder =
        decode User
            |> required "id" int
            |> hardcoded "Alex"
            |> required "email" string

    """ { "id": 123, "email": "sam@example.com" } """
        |> decodeString userDecoder
    --> Success { id = 123, name = "Alex", email = "sam@example.com" }

-}
hardcoded : Elm.Expression -> Elm.Expression -> Elm.Expression
hardcoded arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "hardcoded"
            (Type.function
                [ Type.var "a"
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


{-| Run the given decoder and feed its result into the pipeline at this point.

Consider this example.

    import Json.Decode.Exploration exposing (..)


    type alias User =
        { id : Int
        , name : String
        , email : String
        }

    userDecoder : Decoder User
    userDecoder =
        decode User
            |> required "id" int
            |> custom (at [ "profile", "name" ] string)
            |> required "email" string

    """
    {
        "id": 123,
        "email": "sam@example.com",
        "profile": {"name": "Sam"}
    }
    """
        |> decodeString userDecoder
    --> Success { id = 123, name = "Sam", email = "sam@example.com" }

-}
custom : Elm.Expression -> Elm.Expression -> Elm.Expression
custom arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "custom"
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


{-| Begin a decoding pipeline. This is a synonym for [Json.Decode.succeed](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#succeed),
intended to make things read more clearly.

    type alias User =
        { id : Int
        , email : String
        , name : String
        }

    userDecoder : Decoder User
    userDecoder =
        decode User
            |> required "id" int
            |> required "email" string
            |> optional "name" string ""

-}
decode : Elm.Expression -> Elm.Expression
decode arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "decode"
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


{-| Convert a `Decoder (Result x a)` into a `Decoder a`. Useful when you want
to perform some custom processing just before completing the decoding operation.

    import Json.Decode.Exploration exposing (..)

    type alias User =
        { id : Int
        , name : String
        , email : String
        }

    userDecoder : Decoder User
    userDecoder =
        let
            -- toDecoder gets run *after* all the
            -- (|> required ...) steps are done.
            toDecoder : Int -> String -> String -> Int -> Decoder User
            toDecoder id name email version =
                if version >= 2 then
                    succeed (User id name email)
                else
                    fail "This JSON is from a deprecated source. Please upgrade!"
        in
        decode toDecoder
            |> required "id" int
            |> required "name" string
            |> required "email" string
            |> required "version" int
            -- version is part of toDecoder,
            -- but it is not a part of User
            |> resolve

    """
    {
        "id": 123,
        "name": "Sam",
        "email": "sam@example.com",
        "version": 3
    }
    """
        |> decodeString userDecoder
    --> Success { id = 123, name = "Sam", email = "sam@example.com" }

-}
resolve : Elm.Expression -> Elm.Expression
resolve arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "resolve"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "a" ]
                    ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { required : Elm.Expression
    , requiredAt : Elm.Expression
    , optional : Elm.Expression
    , optionalAt : Elm.Expression
    , hardcoded : Elm.Expression
    , custom : Elm.Expression
    , decode : Elm.Expression
    , resolve : Elm.Expression
    }
id_ =
    { required =
        Elm.valueWith
            moduleName_
            "required"
            (Type.function
                [ Type.string
                , Type.namedWith
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
    , requiredAt =
        Elm.valueWith
            moduleName_
            "requiredAt"
            (Type.function
                [ Type.list Type.string
                , Type.namedWith
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
    , optional =
        Elm.valueWith
            moduleName_
            "optional"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.var "a"
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
    , optionalAt =
        Elm.valueWith
            moduleName_
            "optionalAt"
            (Type.function
                [ Type.list Type.string
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.var "a"
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
    , hardcoded =
        Elm.valueWith
            moduleName_
            "hardcoded"
            (Type.function
                [ Type.var "a"
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
    , custom =
        Elm.valueWith
            moduleName_
            "custom"
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
    , decode =
        Elm.valueWith
            moduleName_
            "decode"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    , resolve =
        Elm.valueWith
            moduleName_
            "resolve"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "a" ]
                    ]
                ]
                (Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                )
            )
    }


