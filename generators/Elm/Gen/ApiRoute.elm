module Elm.Gen.ApiRoute exposing (buildTimeRoutes, capture, getBuildTimeRoutes, id_, int, literal, make_, moduleName_, single, slash, succeed, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "ApiRoute" ]


types_ :
    { response : Type.Annotation
    , apiRouteBuilder : Type.Annotation -> Type.Annotation -> Type.Annotation
    , apiRoute : Type.Annotation -> Type.Annotation
    }
types_ =
    { response = Type.named moduleName_ "Response"
    , apiRouteBuilder =
        \arg0 arg1 ->
            Type.namedWith moduleName_ "ApiRouteBuilder" [ arg0, arg1 ]
    , apiRoute = \arg0 -> Type.namedWith moduleName_ "ApiRoute" [ arg0 ]
    }


make_ : {}
make_ =
    {}


{-| -}
buildTimeRoutes :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
buildTimeRoutes arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "buildTimeRoutes"
            (Type.function
                [ Type.function
                    [ Type.var "constructor" ]
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.list (Type.list Type.string) ]
                    )
                , Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                    , Type.var "constructor"
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRoute"
                    [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| -}
capture : Elm.Expression -> Elm.Expression
capture arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "capture"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.function [ Type.string ] (Type.var "a")
                    , Type.var "constructor"
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a"
                    , Type.function [ Type.string ] (Type.var "constructor")
                    ]
                )
            )
        )
        [ arg1 ]


{-| -}
int : Elm.Expression -> Elm.Expression
int arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "int"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.function [ Type.int ] (Type.var "a")
                    , Type.var "constructor"
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a"
                    , Type.function [ Type.int ] (Type.var "constructor")
                    ]
                )
            )
        )
        [ arg1 ]


{-| -}
literal : Elm.Expression -> Elm.Expression -> Elm.Expression
literal arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "literal"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| -}
single : Elm.Expression -> Elm.Expression
single arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "single"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                    , Type.list Type.string
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRoute"
                    [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                )
            )
        )
        [ arg1 ]


{-| -}
slash : Elm.Expression -> Elm.Expression
slash arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "slash"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
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
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.list Type.string ]
                )
            )
        )
        [ arg1 ]


{-| For internal use by generated code. Not so useful in user-land.
-}
getBuildTimeRoutes : Elm.Expression -> Elm.Expression
getBuildTimeRoutes arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "getBuildTimeRoutes"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRoute"
                    [ Type.var "response" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list Type.string ]
                )
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { buildTimeRoutes : Elm.Expression
    , capture : Elm.Expression
    , int : Elm.Expression
    , literal : Elm.Expression
    , single : Elm.Expression
    , slash : Elm.Expression
    , succeed : Elm.Expression
    , getBuildTimeRoutes : Elm.Expression
    }
id_ =
    { buildTimeRoutes =
        Elm.valueWith
            moduleName_
            "buildTimeRoutes"
            (Type.function
                [ Type.function
                    [ Type.var "constructor" ]
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.list (Type.list Type.string) ]
                    )
                , Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                    , Type.var "constructor"
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRoute"
                    [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                )
            )
    , capture =
        Elm.valueWith
            moduleName_
            "capture"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.function [ Type.string ] (Type.var "a")
                    , Type.var "constructor"
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a"
                    , Type.function [ Type.string ] (Type.var "constructor")
                    ]
                )
            )
    , int =
        Elm.valueWith
            moduleName_
            "int"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.function [ Type.int ] (Type.var "a")
                    , Type.var "constructor"
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a"
                    , Type.function [ Type.int ] (Type.var "constructor")
                    ]
                )
            )
    , literal =
        Elm.valueWith
            moduleName_
            "literal"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
                )
            )
    , single =
        Elm.valueWith
            moduleName_
            "single"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                    , Type.list Type.string
                    ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRoute"
                    [ Type.namedWith [ "ApiRoute" ] "Response" [] ]
                )
            )
    , slash =
        Elm.valueWith
            moduleName_
            "slash"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
                ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.var "constructor" ]
                )
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRouteBuilder"
                    [ Type.var "a", Type.list Type.string ]
                )
            )
    , getBuildTimeRoutes =
        Elm.valueWith
            moduleName_
            "getBuildTimeRoutes"
            (Type.function
                [ Type.namedWith
                    [ "ApiRoute" ]
                    "ApiRoute"
                    [ Type.var "response" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list Type.string ]
                )
            )
    }


