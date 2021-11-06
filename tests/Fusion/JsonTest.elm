module Fusion.JsonTest exposing (..)

import Dict
import Element exposing (..)
import Element.Font as Font
import Expect
import Fusion.HTTP exposing (..)
import Fusion.Json
import Fusion.Types exposing (..)
import Json.Decode as D
import Json.Decode.Pipeline exposing (..)
import Stubs.Response
import Test exposing (Test, describe, test)
import Types exposing (..)


view =
    let
        expected =
            basic2LevelRecordDecoder

        result =
            Fusion.Json.decoderFromMType 0 basic2LevelRecord
    in
    row [ width fill, Font.family [ Font.monospace ] ]
        [ el [ width fill, alignTop ] <| text expected
        , el [ width fill, alignTop ] <| text result
        ]


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


suite : Test
suite =
    describe "decoderFromTType"
        [ test "2 level simple record field" <|
            \() ->
                let
                    result =
                        Fusion.Json.decoderFromMType 0 basic2LevelRecord

                    expected =
                        basic2LevelRecordDecoder

                    expectUnlines f s =
                        String.lines f |> Expect.equal (String.lines s)
                in
                result
                    |> expectUnlines expected
        ]


format =
    D.succeed
        (\first last favorite address ->
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
                (\line1 line2 state country ->
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
