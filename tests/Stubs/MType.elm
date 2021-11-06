module Stubs.MType exposing (..)

import Fusion.Types exposing (..)


basic2LevelRecord =
    MRecord "Unknown"
        []
        [ ( "first", MString (At [] "first") )
        , ( "last", MString (At [] "last") )
        , ( "favorite", MString (At [] "favorite") )
        , ( "address"
          , MRecord "Unknown"
                []
                [ ( "line1", MString (At [] "line1") )
                , ( "line2", MString (At [] "line2") )
                , ( "state", MString (At [] "state") )
                , ( "country", MString (At [] "country") )
                ]
                (At [] "address")
          )
        ]
        Root


basic2LevelRecordDecoder =
    """
D.succeed
    (\\first last favorite address ->
        { first = first
        , last = last
        , favorite = favorite
        , address = address
        }
    )
    |> required "first" D.string
    |> required "last" D.string
    |> required "favorite" D.string
    |> required "address"
        (D.succeed
            (\\line1 line2 state country ->
                { line1 = line1
                , line2 = line2
                , state = state
                , country = country
                }
            )
            |> required "line1" D.string
            |> required "line2" D.string
            |> required "state" D.string
            |> required "country" D.string
        )
        """ |> String.trim
