module Fusion.VType exposing (..)

import Fusion.Types exposing (..)


toElmCodeString : Int -> VType -> String
toElmCodeString indent stub =
    let
        recurse =
            toElmCodeString (indent + 1)

        i =
            String.repeat (indent * 4) " "
    in
    case stub of
        VString s ->
            "\"" ++ s ++ "\""

        VInt int ->
            String.fromInt int

        VFloat float ->
            String.fromFloat float

        VBool b ->
            case b of
                True ->
                    "True"

                False ->
                    "False"

        VList ttype _ ->
            "List TODO"

        VCustom name params constructors ->
            let
                viewConstructors =
                    constructors
                        |> List.map
                            (\( cname, cparams, vparams ) ->
                                let
                                    cparams_ =
                                        vparams
                                            |> List.map (\param -> recurse param)
                                in
                                "| " ++ cname ++ String.join " " cparams_
                            )
                        |> String.join " "
            in
            "type " ++ name ++ viewConstructors

        VRecord name params fields ->
            let
                viewFields =
                    fields
                        |> List.map
                            (\( fname, ttype, vtype ) ->
                                fname ++ " = " ++ recurse vtype
                            )
                        |> String.join ("\n" ++ i ++ ", ")
            in
            case name of
                "Unknown" ->
                    "\n" ++ i ++ "{ " ++ viewFields ++ "\n" ++ i ++ "}"

                _ ->
                    i ++ "type alias " ++ name ++ " {\n" ++ viewFields ++ "\n}"

        VParam name ->
            name

        VMaybe mtype vtype ->
            case vtype of
                Just vtype_ ->
                    recurse vtype_

                Nothing ->
                    "Nothing"

        VRecursive name ->
            name

        VUnimplemented ->
            "TUnimplemented"

        VError error ->
            "ERROR[" ++ error ++ "]"
