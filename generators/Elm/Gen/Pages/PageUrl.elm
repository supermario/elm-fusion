module Elm.Gen.Pages.PageUrl exposing (id_, make_, moduleName_, toUrl, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "PageUrl" ]


types_ : { pageUrl : Type.Annotation }
types_ =
    { pageUrl = Type.named moduleName_ "PageUrl" }


make_ : {}
make_ =
    {}


{-| -}
toUrl : Elm.Expression -> Elm.Expression
toUrl arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toUrl"
            (Type.function
                [ Type.namedWith [ "Pages", "PageUrl" ] "PageUrl" [] ]
                (Type.namedWith [ "Url" ] "Url" [])
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { toUrl : Elm.Expression }
id_ =
    { toUrl =
        Elm.valueWith
            moduleName_
            "toUrl"
            (Type.function
                [ Type.namedWith [ "Pages", "PageUrl" ] "PageUrl" [] ]
                (Type.namedWith [ "Url" ] "Url" [])
            )
    }


