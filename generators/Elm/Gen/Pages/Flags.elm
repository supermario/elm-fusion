module Elm.Gen.Pages.Flags exposing (id_, make_, moduleName_, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Flags" ]


types_ : { flags : Type.Annotation }
types_ =
    { flags = Type.named moduleName_ "Flags" }


make_ :
    { flags :
        { browserFlags : Elm.Expression -> Elm.Expression
        , preRenderFlags : Elm.Expression
        }
    }
make_ =
    { flags =
        { browserFlags =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BrowserFlags"
                        (Type.namedWith [] "Flags" [])
                    )
                    [ ar0 ]
        , preRenderFlags =
            Elm.valueWith
                moduleName_
                "PreRenderFlags"
                (Type.namedWith [] "Flags" [])
        }
    }


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : {}
id_ =
    {}


