module Elm.Gen.Pages.Url exposing (external, fromPath, id_, make_, moduleName_, toAbsoluteUrl, toString, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Url" ]


types_ : { url : Type.Annotation }
types_ =
    { url = Type.named moduleName_ "Url" }


make_ : {}
make_ =
    {}


{-| -}
external : Elm.Expression -> Elm.Expression
external arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "external"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "Pages", "Url" ] "Url" [])
            )
        )
        [ arg1 ]


{-| -}
fromPath : Elm.Expression -> Elm.Expression
fromPath arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromPath"
            (Type.function
                [ Type.namedWith [ "Path" ] "Path" [] ]
                (Type.namedWith [ "Pages", "Url" ] "Url" [])
            )
        )
        [ arg1 ]


{-| -}
toAbsoluteUrl : Elm.Expression -> Elm.Expression -> Elm.Expression
toAbsoluteUrl arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toAbsoluteUrl"
            (Type.function
                [ Type.string, Type.namedWith [ "Pages", "Url" ] "Url" [] ]
                Type.string
            )
        )
        [ arg1, arg2 ]


{-| -}
toString : Elm.Expression -> Elm.Expression
toString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toString"
            (Type.function
                [ Type.namedWith [ "Pages", "Url" ] "Url" [] ]
                Type.string
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { external : Elm.Expression
    , fromPath : Elm.Expression
    , toAbsoluteUrl : Elm.Expression
    , toString : Elm.Expression
    }
id_ =
    { external =
        Elm.valueWith
            moduleName_
            "external"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "Pages", "Url" ] "Url" [])
            )
    , fromPath =
        Elm.valueWith
            moduleName_
            "fromPath"
            (Type.function
                [ Type.namedWith [ "Path" ] "Path" [] ]
                (Type.namedWith [ "Pages", "Url" ] "Url" [])
            )
    , toAbsoluteUrl =
        Elm.valueWith
            moduleName_
            "toAbsoluteUrl"
            (Type.function
                [ Type.string, Type.namedWith [ "Pages", "Url" ] "Url" [] ]
                Type.string
            )
    , toString =
        Elm.valueWith
            moduleName_
            "toString"
            (Type.function
                [ Type.namedWith [ "Pages", "Url" ] "Url" [] ]
                Type.string
            )
    }


