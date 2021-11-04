module Elm.Gen.Pages.Internal.Router exposing (firstMatch, fromOptionalSplat, id_, make_, maybeToList, moduleName_, nonEmptyToList, toNonEmpty, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Internal", "Router" ]


types_ : { matcher : Type.Annotation -> Type.Annotation }
types_ =
    { matcher = \arg0 -> Type.namedWith moduleName_ "Matcher" [ arg0 ] }


make_ : {}
make_ =
    {}


{-| -}
firstMatch : List Elm.Expression -> Elm.Expression -> Elm.Expression
firstMatch arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "firstMatch"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Pages", "Internal", "Router" ]
                        "Matcher"
                        [ Type.var "route" ]
                    )
                , Type.string
                ]
                (Type.maybe (Type.var "route"))
            )
        )
        [ Elm.list arg1, arg2 ]


{-| -}
fromOptionalSplat : Elm.Expression -> Elm.Expression
fromOptionalSplat arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromOptionalSplat"
            (Type.function [ Type.maybe Type.string ] (Type.list Type.string))
        )
        [ arg1 ]


{-| -}
maybeToList : Elm.Expression -> Elm.Expression
maybeToList arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "maybeToList"
            (Type.function [ Type.maybe Type.string ] (Type.list Type.string))
        )
        [ arg1 ]


{-| -}
nonEmptyToList : Elm.Expression -> Elm.Expression
nonEmptyToList arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "nonEmptyToList"
            (Type.function
                [ Type.tuple Type.string (Type.list Type.string) ]
                (Type.list Type.string)
            )
        )
        [ arg1 ]


{-| -}
toNonEmpty : Elm.Expression -> Elm.Expression
toNonEmpty arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toNonEmpty"
            (Type.function
                [ Type.string ]
                (Type.tuple Type.string (Type.list Type.string))
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { firstMatch : Elm.Expression
    , fromOptionalSplat : Elm.Expression
    , maybeToList : Elm.Expression
    , nonEmptyToList : Elm.Expression
    , toNonEmpty : Elm.Expression
    }
id_ =
    { firstMatch =
        Elm.valueWith
            moduleName_
            "firstMatch"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Pages", "Internal", "Router" ]
                        "Matcher"
                        [ Type.var "route" ]
                    )
                , Type.string
                ]
                (Type.maybe (Type.var "route"))
            )
    , fromOptionalSplat =
        Elm.valueWith
            moduleName_
            "fromOptionalSplat"
            (Type.function [ Type.maybe Type.string ] (Type.list Type.string))
    , maybeToList =
        Elm.valueWith
            moduleName_
            "maybeToList"
            (Type.function [ Type.maybe Type.string ] (Type.list Type.string))
    , nonEmptyToList =
        Elm.valueWith
            moduleName_
            "nonEmptyToList"
            (Type.function
                [ Type.tuple Type.string (Type.list Type.string) ]
                (Type.list Type.string)
            )
    , toNonEmpty =
        Elm.valueWith
            moduleName_
            "toNonEmpty"
            (Type.function
                [ Type.string ]
                (Type.tuple Type.string (Type.list Type.string))
            )
    }


