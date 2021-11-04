module Elm.Gen.Pages.Internal.NotFoundReason exposing (codec, document, id_, make_, moduleName_, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Internal", "NotFoundReason" ]


types_ :
    { record : Type.Annotation
    , payload : Type.Annotation
    , notFoundReason : Type.Annotation
    , moduleContext : Type.Annotation
    }
types_ =
    { record = Type.named moduleName_ "Record"
    , payload = Type.named moduleName_ "Payload"
    , notFoundReason = Type.named moduleName_ "NotFoundReason"
    , moduleContext = Type.named moduleName_ "ModuleContext"
    }


make_ :
    { notFoundReason :
        { noMatchingRoute : Elm.Expression
        , notPrerendered : Elm.Expression -> Elm.Expression -> Elm.Expression
        , notPrerenderedOrHandledByFallback :
            Elm.Expression -> Elm.Expression -> Elm.Expression
        , unhandledServerRoute : Elm.Expression -> Elm.Expression
        }
    }
make_ =
    { notFoundReason =
        { noMatchingRoute =
            Elm.valueWith
                moduleName_
                "NoMatchingRoute"
                (Type.namedWith [] "NotFoundReason" [])
        , notPrerendered =
            \ar0 ar1 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "NotPrerendered"
                        (Type.namedWith [] "NotFoundReason" [])
                    )
                    [ ar0, ar1 ]
        , notPrerenderedOrHandledByFallback =
            \ar0 ar1 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "NotPrerenderedOrHandledByFallback"
                        (Type.namedWith [] "NotFoundReason" [])
                    )
                    [ ar0, ar1 ]
        , unhandledServerRoute =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "UnhandledServerRoute"
                        (Type.namedWith [] "NotFoundReason" [])
                    )
                    [ ar0 ]
        }
    }


{-| -}
codec : Elm.Expression
codec =
    Elm.valueWith
        moduleName_
        "codec"
        (Type.namedWith
            [ "Codec" ]
            "Codec"
            [ Type.namedWith
                [ "Pages", "Internal", "NotFoundReason" ]
                "Payload"
                []
            ]
        )


{-| -}
document : List Elm.Expression -> Elm.Expression -> Elm.Expression
document arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "document"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Pages", "Internal", "RoutePattern" ]
                        "RoutePattern"
                        []
                    )
                , Type.namedWith
                    [ "Pages", "Internal", "NotFoundReason" ]
                    "Payload"
                    []
                ]
                (Type.record
                    [ ( "title", Type.string )
                    , ( "body"
                      , Type.namedWith [ "Html" ] "Html" [ Type.var "msg" ]
                      )
                    ]
                )
            )
        )
        [ Elm.list arg1, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { codec : Elm.Expression, document : Elm.Expression }
id_ =
    { codec =
        Elm.valueWith
            moduleName_
            "codec"
            (Type.namedWith
                [ "Codec" ]
                "Codec"
                [ Type.namedWith
                    [ "Pages", "Internal", "NotFoundReason" ]
                    "Payload"
                    []
                ]
            )
    , document =
        Elm.valueWith
            moduleName_
            "document"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Pages", "Internal", "RoutePattern" ]
                        "RoutePattern"
                        []
                    )
                , Type.namedWith
                    [ "Pages", "Internal", "NotFoundReason" ]
                    "Payload"
                    []
                ]
                (Type.record
                    [ ( "title", Type.string )
                    , ( "body"
                      , Type.namedWith [ "Html" ] "Html" [ Type.var "msg" ]
                      )
                    ]
                )
            )
    }


