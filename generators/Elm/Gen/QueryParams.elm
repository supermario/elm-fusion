module Elm.Gen.QueryParams exposing (andThen, fail, fromResult, fromString, id_, make_, map2, moduleName_, oneOf, optionalString, parse, string, strings, succeed, toDict, toString, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "QueryParams" ]


types_ :
    { parser : Type.Annotation -> Type.Annotation
    , queryParams : Type.Annotation
    }
types_ =
    { parser = \arg0 -> Type.namedWith moduleName_ "Parser" [ arg0 ]
    , queryParams = Type.named moduleName_ "QueryParams"
    }


make_ : {}
make_ =
    {}


{-| -}
andThen : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
andThen arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "b" ])
                , Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ]
                ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "b" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| -}
fail : Elm.Expression -> Elm.Expression
fail arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
        )
        [ arg1 ]


{-| -}
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
                    [ Type.string, Type.var "a" ]
                ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
        )
        [ arg1 ]


{-| -}
fromString : Elm.Expression -> Elm.Expression
fromString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromString"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "QueryParams" ] "QueryParams" [])
            )
        )
        [ arg1 ]


{-| -}
optionalString : Elm.Expression -> Elm.Expression
optionalString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "optionalString"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "QueryParams" ]
                    "Parser"
                    [ Type.maybe Type.string ]
                )
            )
        )
        [ arg1 ]


{-| -}
parse : Elm.Expression -> Elm.Expression -> Elm.Expression
parse arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "parse"
            (Type.function
                [ Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ]
                , Type.namedWith [ "QueryParams" ] "QueryParams" []
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.string, Type.var "a" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
string : Elm.Expression -> Elm.Expression
string arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "string"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.string ])
            )
        )
        [ arg1 ]


{-| -}
strings : Elm.Expression -> Elm.Expression
strings arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "strings"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "QueryParams" ]
                    "Parser"
                    [ Type.list Type.string ]
                )
            )
        )
        [ arg1 ]


{-| -}
succeed : Elm.Expression -> Elm.Expression
succeed arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
        )
        [ arg1 ]


{-| -}
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
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "combined")
                , Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ]
                , Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "b" ]
                ]
                (Type.namedWith
                    [ "QueryParams" ]
                    "Parser"
                    [ Type.var "combined" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| -}
oneOf : List Elm.Expression -> Elm.Expression
oneOf arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.list
                    (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
                ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
        )
        [ Elm.list arg1 ]


{-| -}
toDict : Elm.Expression -> Elm.Expression
toDict arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toDict"
            (Type.function
                [ Type.namedWith [ "QueryParams" ] "QueryParams" [] ]
                (Type.namedWith
                    [ "Dict" ]
                    "Dict"
                    [ Type.string, Type.list Type.string ]
                )
            )
        )
        [ arg1 ]


{-| -}
toString : Elm.Expression -> Elm.Expression
toString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toString"
            (Type.function
                [ Type.namedWith [ "QueryParams" ] "QueryParams" [] ]
                Type.string
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { andThen : Elm.Expression
    , fail : Elm.Expression
    , fromResult : Elm.Expression
    , fromString : Elm.Expression
    , optionalString : Elm.Expression
    , parse : Elm.Expression
    , string : Elm.Expression
    , strings : Elm.Expression
    , succeed : Elm.Expression
    , map2 : Elm.Expression
    , oneOf : Elm.Expression
    , toDict : Elm.Expression
    , toString : Elm.Expression
    }
id_ =
    { andThen =
        Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "b" ])
                , Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ]
                ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "b" ])
            )
    , fail =
        Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
    , fromResult =
        Elm.valueWith
            moduleName_
            "fromResult"
            (Type.function
                [ Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.string, Type.var "a" ]
                ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
    , fromString =
        Elm.valueWith
            moduleName_
            "fromString"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "QueryParams" ] "QueryParams" [])
            )
    , optionalString =
        Elm.valueWith
            moduleName_
            "optionalString"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "QueryParams" ]
                    "Parser"
                    [ Type.maybe Type.string ]
                )
            )
    , parse =
        Elm.valueWith
            moduleName_
            "parse"
            (Type.function
                [ Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ]
                , Type.namedWith [ "QueryParams" ] "QueryParams" []
                ]
                (Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.string, Type.var "a" ]
                )
            )
    , string =
        Elm.valueWith
            moduleName_
            "string"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.string ])
            )
    , strings =
        Elm.valueWith
            moduleName_
            "strings"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "QueryParams" ]
                    "Parser"
                    [ Type.list Type.string ]
                )
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "combined")
                , Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ]
                , Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "b" ]
                ]
                (Type.namedWith
                    [ "QueryParams" ]
                    "Parser"
                    [ Type.var "combined" ]
                )
            )
    , oneOf =
        Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.list
                    (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
                ]
                (Type.namedWith [ "QueryParams" ] "Parser" [ Type.var "a" ])
            )
    , toDict =
        Elm.valueWith
            moduleName_
            "toDict"
            (Type.function
                [ Type.namedWith [ "QueryParams" ] "QueryParams" [] ]
                (Type.namedWith
                    [ "Dict" ]
                    "Dict"
                    [ Type.string, Type.list Type.string ]
                )
            )
    , toString =
        Elm.valueWith
            moduleName_
            "toString"
            (Type.function
                [ Type.namedWith [ "QueryParams" ] "QueryParams" [] ]
                Type.string
            )
    }


