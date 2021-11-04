module Elm.Gen.Pages.Internal.Platform exposing (application, id_, make_, moduleName_, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Internal", "Platform" ]


types_ :
    { program :
        Type.Annotation
        -> Type.Annotation
        -> Type.Annotation
        -> Type.Annotation
        -> Type.Annotation
    , msg : Type.Annotation -> Type.Annotation
    , model :
        Type.Annotation -> Type.Annotation -> Type.Annotation -> Type.Annotation
    , flags : Type.Annotation
    }
types_ =
    { program =
        \arg0 arg1 arg2 arg3 ->
            Type.namedWith moduleName_ "Program" [ arg0, arg1, arg2, arg3 ]
    , msg = \arg0 -> Type.namedWith moduleName_ "Msg" [ arg0 ]
    , model =
        \arg0 arg1 arg2 ->
            Type.namedWith moduleName_ "Model" [ arg0, arg1, arg2 ]
    , flags = Type.named moduleName_ "Flags"
    }


make_ : {}
make_ =
    {}


{-| -}
application : Elm.Expression -> Elm.Expression
application arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "application"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.var "route"
                    , Type.var "staticData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Program"
                    [ Type.namedWith
                        [ "Pages", "Internal", "Platform" ]
                        "Flags"
                        []
                    , Type.namedWith
                        [ "Pages", "Internal", "Platform" ]
                        "Model"
                        [ Type.var "userModel"
                        , Type.var "pageData"
                        , Type.var "sharedData"
                        ]
                    , Type.namedWith
                        [ "Pages", "Internal", "Platform" ]
                        "Msg"
                        [ Type.var "userMsg" ]
                    ]
                )
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { application : Elm.Expression }
id_ =
    { application =
        Elm.valueWith
            moduleName_
            "application"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.var "route"
                    , Type.var "staticData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                ]
                (Type.namedWith
                    [ "Platform" ]
                    "Program"
                    [ Type.namedWith
                        [ "Pages", "Internal", "Platform" ]
                        "Flags"
                        []
                    , Type.namedWith
                        [ "Pages", "Internal", "Platform" ]
                        "Model"
                        [ Type.var "userModel"
                        , Type.var "pageData"
                        , Type.var "sharedData"
                        ]
                    , Type.namedWith
                        [ "Pages", "Internal", "Platform" ]
                        "Msg"
                        [ Type.var "userMsg" ]
                    ]
                )
            )
    }


