module Fusion.Json exposing (..)

import Fusion.Types exposing (..)


decoderFromTType ttype =
    case ttype of
        TInt ->
            "D.int"

        TFloat ->
            "D.float"

        TString ->
            "D.string"

        TBool ->
            "D.bool"

        TList ttype_ ->
            "D.list (" ++ decoderFromTType ttype_ ++ ")"

        TCustom name tParams params ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ Debug.toString ttype ++ "\""

        TRecord name tParams fields ->
            ([ "D.succeed " ++ name
             ]
                ++ (fields |> List.map (\( fieldName, t ) -> "    |> required \"" ++ fieldName ++ "\" " ++ decoderFromTType t))
            )
                |> String.join "\n"

        -- |> List.intersperse "\n"
        -- "Debug.crash \"unimplemented decoderFromTtype: " ++ Debug.toString ttype ++ "\""
        TRecursive name ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ Debug.toString ttype ++ "\""

        TUnimplemented ->
            "Debug.crash \"unimplemented decoderFromTtype: " ++ Debug.toString ttype ++ "\""
