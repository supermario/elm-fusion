module Fusion.Json exposing (..)

import Fusion.Types exposing (..)
import Helpers exposing (..)
import List.Extra as List


decoderFromMType : Int -> MType -> String
decoderFromMType indent mtype =
    let
        recurse =
            decoderFromMType (indent + 1)

        i =
            String.repeat (indent * tabSize) " "
    in
    case mtype of
        MInt jp ->
            "D.int"

        MFloat jp ->
            "D.float"

        MString jp ->
            "D.string"

        MBool jp ->
            "D.bool"

        MList mtype_ jp ->
            "D.list (" ++ recurse mtype_ ++ ")"

        MCustom name tParams params jp ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ toString mtype ++ "\""

        MRecord name tParams fields jp ->
            case name of
                "Unknown" ->
                    let
                        fieldNames =
                            fields |> List.map (\( fieldName, t ) -> fieldName)

                        anonymousFunction =
                            "(\\" ++ String.join " " fieldNames

                        anonymousRecord =
                            fieldNames
                                |> List.indexedMap
                                    (\j n ->
                                        let
                                            prefix =
                                                if j == 0 then
                                                    "{"

                                                else
                                                    ","
                                        in
                                        i ++ tab ++ tab ++ prefix ++ " " ++ n ++ " = " ++ n
                                    )
                                |> (\v -> v ++ [ i ++ tab ++ tab ++ "}" ])
                    in
                    -- This record is not yet named, used anonymous record syntax
                    ([ "D.succeed"
                     , i ++ tab ++ anonymousFunction ++ " ->"
                     ]
                        ++ anonymousRecord
                        ++ [ i ++ tab ++ ")" ]
                        ++ (fields
                                |> List.map
                                    (\( fieldName, t ) ->
                                        i ++ tab ++ "|> required \"" ++ fieldName ++ "\"" ++ parenthesisIfNeeded indent t
                                    )
                           )
                    )
                        |> String.join "\n"

                _ ->
                    ([ "D.succeed " ++ name
                     ]
                        ++ (fields |> List.map (\( fieldName, t ) -> i ++ tab ++ "|> required \"" ++ fieldName ++ "\" " ++ recurse t))
                    )
                        |> String.join "\n"

        MParam name ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ toString mtype ++ "\""

        MMaybe mtype_ jp ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ toString mtype ++ "\""

        -- |> List.intersperse "\n"
        -- "Debug.crash \"unimplemented decoderFromTtype: " ++ toString mtype ++ "\""
        MRecursive name ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ toString mtype ++ "\""

        MUnimplemented ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ toString mtype ++ "\""


parenthesisIfNeeded indent mtype =
    let
        needed =
            case mtype of
                MRecord name tParams fields jp ->
                    True

                _ ->
                    False

        fn =
            if needed then
                decoderFromMType (indent + 2)

            else
                decoderFromMType (indent + 1)

        i =
            String.repeat (indent * tabSize) " "
    in
    if needed then
        "\n" ++ i ++ tab ++ tab ++ "(" ++ fn mtype ++ "\n" ++ i ++ tab ++ tab ++ ")"

    else
        " " ++ fn mtype


tab =
    String.repeat tabSize " "


tabSize =
    4
