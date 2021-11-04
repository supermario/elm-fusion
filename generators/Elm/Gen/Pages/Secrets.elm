module Elm.Gen.Pages.Secrets exposing (id_, make_, map, moduleName_, succeed, types_, with)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Secrets" ]


types_ : { value : Type.Annotation -> Type.Annotation }
types_ =
    { value = \arg0 -> Type.namedWith moduleName_ "Value" [ arg0 ] }


make_ : {}
make_ =
    {}


{-| Map a Secret's raw value into an arbitrary type or value.
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "valueA" ] (Type.var "valueB")
                , Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "valueA" ]
                ]
                (Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "valueB" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Hardcode a secret value. Or, this can be used to start a pipeline-style value with several different secrets (see
the example at the top of this page).

    import Pages.Secrets as Secrets

    Secrets.succeed "hardcoded-secret"

-}
succeed : Elm.Expression -> Elm.Expression
succeed arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "value" ]
                (Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 ]


{-| Allows you to chain together multiple secrets. See the top of this page for a full example.
-}
with : Elm.Expression -> Elm.Expression -> Elm.Expression
with arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "with"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.function [ Type.string ] (Type.var "value") ]
                ]
                (Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { map : Elm.Expression, succeed : Elm.Expression, with : Elm.Expression }
id_ =
    { map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "valueA" ] (Type.var "valueB")
                , Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "valueA" ]
                ]
                (Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "valueB" ]
                )
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "value" ]
                (Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "value" ]
                )
            )
    , with =
        Elm.valueWith
            moduleName_
            "with"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.function [ Type.string ] (Type.var "value") ]
                ]
                (Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.var "value" ]
                )
            )
    }


