module Elm.Gen.Pages.Internal.RoutePattern exposing (codec, id_, make_, moduleName_, types_, view)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Internal", "RoutePattern" ]


types_ :
    { segment : Type.Annotation
    , routePattern : Type.Annotation
    , ending : Type.Annotation
    }
types_ =
    { segment = Type.named moduleName_ "Segment"
    , routePattern = Type.named moduleName_ "RoutePattern"
    , ending = Type.named moduleName_ "Ending"
    }


make_ :
    { segment :
        { staticSegment : Elm.Expression -> Elm.Expression
        , dynamicSegment : Elm.Expression -> Elm.Expression
        }
    , ending :
        { optional : Elm.Expression -> Elm.Expression
        , requiredSplat : Elm.Expression
        , optionalSplat : Elm.Expression
        }
    }
make_ =
    { segment =
        { staticSegment =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "StaticSegment"
                        (Type.namedWith [] "Segment" [])
                    )
                    [ ar0 ]
        , dynamicSegment =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "DynamicSegment"
                        (Type.namedWith [] "Segment" [])
                    )
                    [ ar0 ]
        }
    , ending =
        { optional =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "Optional"
                        (Type.namedWith [] "Ending" [])
                    )
                    [ ar0 ]
        , requiredSplat =
            Elm.valueWith
                moduleName_
                "RequiredSplat"
                (Type.namedWith [] "Ending" [])
        , optionalSplat =
            Elm.valueWith
                moduleName_
                "OptionalSplat"
                (Type.namedWith [] "Ending" [])
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
                [ "Pages", "Internal", "RoutePattern" ]
                "RoutePattern"
                []
            ]
        )


{-| -}
view : Elm.Expression -> Elm.Expression
view arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "view"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Internal", "RoutePattern" ]
                    "RoutePattern"
                    []
                ]
                (Type.namedWith [ "Html" ] "Html" [ Type.var "msg" ])
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { codec : Elm.Expression, view : Elm.Expression }
id_ =
    { codec =
        Elm.valueWith
            moduleName_
            "codec"
            (Type.namedWith
                [ "Codec" ]
                "Codec"
                [ Type.namedWith
                    [ "Pages", "Internal", "RoutePattern" ]
                    "RoutePattern"
                    []
                ]
            )
    , view =
        Elm.valueWith
            moduleName_
            "view"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Internal", "RoutePattern" ]
                    "RoutePattern"
                    []
                ]
                (Type.namedWith [ "Html" ] "Html" [ Type.var "msg" ])
            )
    }


