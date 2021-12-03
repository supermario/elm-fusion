module Fusion.AddAllDynamicDecodeTest exposing (..)

import Dict
import Element exposing (..)
import Element.Font as Font
import Expect
import Fusion.HTTP exposing (..)
import Fusion.Json
import Fusion.Operation
import Fusion.Transform
import Fusion.Types exposing (..)
import Fusion.VType
import Json.Decode as D
import Json.Decode.Pipeline exposing (..)
import String.Extra as String
import Stubs.MType exposing (..)
import Stubs.Response
import Test exposing (Test, describe, test)
import Types exposing (..)
import View.DecodePreview



{-

   E2E test for:

     JSON String
       -> infer type
       -> add all fields
       -> generate decoder from fusion AST
       -> attempt decode of original JSON string

-}


suite : Test
suite =
    describe "E2E automatic decoding from JSON"
        [ test "simple json" <|
            \() ->
                """
                {
                  "first": "Jane",
                  "last": "Doe",
                  "age": 34
                }
                """
                    |> expectAddAllTranformationToElmCode
                        """
                        { first = "Jane"
                        , last = "Doe"
                        , age = 34
                        }
                        """
        , test "2 level simple record field" <|
            \() ->
                """
                {
                  "first": "Jane",
                  "last": "Doe",
                  "favorite": "Chocolate",
                  "address" : {
                      "line1": "123 Test St",
                      "line2": null,
                      "state": "NSW",
                      "country": "AU"
                  }
                }
                """
                    |> expectAddAllTranformationToElmCode
                        """
                        { first = "Jane"
                        , last = "Doe"
                        , favorite = "Chocolate"
                        , address = 
                            { line1 = "123 Test St"
                            , line2 = Nothing
                            , state = "NSW"
                            , country = "AU"
                            }
                        }
                        """
        ]


expectAddAllTranformationToElmCode expectedRaw input =
    let
        json : Result D.Error JsonValue
        json =
            input
                |> String.unindent
                |> String.trim
                |> D.decodeString decodeJsonAst

        vtype =
            json
                |> Debug.log "json value"
                |> Result.map
                    (\jv ->
                        case Fusion.Operation.fusionAddAll [] jv EmptyDecoder of
                            EmptyDecoder ->
                                VError "got EmptyDecoder"

                            FusionType mtype ->
                                Fusion.Transform.extractVType mtype jv
                    )
                |> Debug.log "extracted vtype"
                |> Result.withDefault (VError "error in decodeJsonAst")

        result =
            Fusion.VType.toElmCodeString 0 vtype
                |> String.trim

        expected =
            expectedRaw
                |> String.unindent
                |> String.trim

        expectUnlines f s =
            String.lines f |> Expect.equal (String.lines s)
    in
    result
        |> expectUnlines expected
