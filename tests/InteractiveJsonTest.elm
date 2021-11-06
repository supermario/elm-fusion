module InteractiveJsonTest exposing (..)

import Dict
import Expect
import Frontend
import Fusion.HTTP exposing (..)
import Fusion.Types exposing (..)
import Stubs.Response
import Test exposing (Test, describe, test)
import Types exposing (..)


suite : Test
suite =
    describe "InteractiveJsonTest"
        [ describe "fusionAddField for records"
            [ test "adding a single record field at root" <|
                \() ->
                    let
                        existingDecoder =
                            EmptyDecoder

                        msg =
                            JsonAddField [] "name" (JString "Chocolate")

                        expected =
                            MRecord "Unknown" [] [ ( "name", MString (At [] "name") ) ] Root
                    in
                    shadowUpdate msg existingDecoder
                        |> Expect.equal (FusionType expected)
            , test "all fields at root" <|
                \() ->
                    let
                        existingDecoder =
                            EmptyDecoder

                        msg =
                            JsonAddAll []
                                (JObject
                                    [ ( "first", JString "Jane" )
                                    , ( "last", JString "Doe" )
                                    , ( "favorite", JString "Chocolate" )
                                    , ( "address"
                                      , JObject
                                            [ ( "line1", JString "123 Test St" )
                                            , ( "line2", JString "Testburbia" )
                                            , ( "state", JString "NSW" )
                                            , ( "country", JString "AU" )
                                            ]
                                      )
                                    ]
                                )

                        expected =
                            MRecord "Unknown"
                                []
                                [ ( "address"
                                  , MRecord "Unknown"
                                        []
                                        [ ( "line1", MString (At [] "line1") )
                                        , ( "line2", MString (At [] "line2") )
                                        , ( "state", MString (At [] "state") )
                                        , ( "country", MString (At [] "country") )
                                        ]
                                        (At [] "address")
                                  )
                                , ( "favorite", MString (At [] "favorite") )
                                , ( "first", MString (At [] "first") )
                                , ( "last", MString (At [] "last") )
                                ]
                                Root
                    in
                    shadowUpdate msg existingDecoder
                        |> Expect.equal (FusionType expected)
            ]
        ]


shadowUpdate msg existingDecoder =
    case msg of
        JsonAddField parents f jv ->
            fusionAddField parents f jv existingDecoder

        JsonAddAll parents jv ->
            fusionAddAll parents jv existingDecoder

        x ->
            Debug.todo <| "missing case: " ++ Debug.toString x
