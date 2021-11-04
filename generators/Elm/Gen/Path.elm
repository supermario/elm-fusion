module Elm.Gen.Path exposing (fromString, id_, join, make_, moduleName_, toAbsolute, toRelative, toSegments, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Path" ]


types_ : { path : Type.Annotation }
types_ =
    { path = Type.named moduleName_ "Path" }


make_ : {}
make_ =
    {}


{-| Create a Path from multiple path parts. Each part can either be a single path segment, like `blog`, or a
multi-part path part, like `blog/post-1`.
-}
join : List Elm.Expression -> Elm.Expression
join arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "join"
            (Type.function
                [ Type.list Type.string ]
                (Type.namedWith [ "Path" ] "Path" [])
            )
        )
        [ Elm.list arg1 ]


{-| Create a Path from a path String.

    Path.fromString "blog/post-1/"
        |> Path.toAbsolute
        |> Expect.equal "/blog/post-1"

-}
fromString : Elm.Expression -> Elm.Expression
fromString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromString"
            (Type.function [ Type.string ] (Type.namedWith [ "Path" ] "Path" [])
            )
        )
        [ arg1 ]


{-| Turn a Path to an absolute URL (with no trailing slash).
-}
toAbsolute : Elm.Expression -> Elm.Expression
toAbsolute arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toAbsolute"
            (Type.function [ Type.namedWith [ "Path" ] "Path" [] ] Type.string)
        )
        [ arg1 ]


{-| Turn a Path to a relative URL.
-}
toRelative : Elm.Expression -> Elm.Expression
toRelative arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toRelative"
            (Type.function [ Type.namedWith [ "Path" ] "Path" [] ] Type.string)
        )
        [ arg1 ]


{-| -}
toSegments : Elm.Expression -> Elm.Expression
toSegments arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toSegments"
            (Type.function
                [ Type.namedWith [ "Path" ] "Path" [] ]
                (Type.list Type.string)
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { join : Elm.Expression
    , fromString : Elm.Expression
    , toAbsolute : Elm.Expression
    , toRelative : Elm.Expression
    , toSegments : Elm.Expression
    }
id_ =
    { join =
        Elm.valueWith
            moduleName_
            "join"
            (Type.function
                [ Type.list Type.string ]
                (Type.namedWith [ "Path" ] "Path" [])
            )
    , fromString =
        Elm.valueWith
            moduleName_
            "fromString"
            (Type.function [ Type.string ] (Type.namedWith [ "Path" ] "Path" [])
            )
    , toAbsolute =
        Elm.valueWith
            moduleName_
            "toAbsolute"
            (Type.function [ Type.namedWith [ "Path" ] "Path" [] ] Type.string)
    , toRelative =
        Elm.valueWith
            moduleName_
            "toRelative"
            (Type.function [ Type.namedWith [ "Path" ] "Path" [] ] Type.string)
    , toSegments =
        Elm.valueWith
            moduleName_
            "toSegments"
            (Type.function
                [ Type.namedWith [ "Path" ] "Path" [] ]
                (Type.list Type.string)
            )
    }


