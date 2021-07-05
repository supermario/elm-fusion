module Fusion.View exposing (..)

import Colors exposing (fromHex)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Fusion.Types exposing (..)


blue =
    fromHex "#4196ad"


green =
    fromHex "#73c990"


orange =
    fromHex "#d19a66"


white =
    fromHex "#abb2bf"


purple =
    fromHex "#c677dd"


stringGreen =
    fromHex "#98c37a"


red =
    fromHex "#fb726d"


charcoal =
    fromHex "#333"


viewType t =
    row [ spacing 10, padding 20 ]
        [ el [ Border.width 1, Border.color blue ] <| typeRich t
        ]


typeString : Int -> TType -> String
typeString indent stub =
    let
        recurse =
            typeString (indent + 1)

        i =
            String.repeat indent " "
    in
    case stub of
        TString ->
            "String"

        TInt ->
            "Int"

        TFloat ->
            "Float"

        TBool ->
            "Bool"

        TList ttype ->
            "List (" ++ recurse ttype ++ ")"

        TCustom name params constructors ->
            let
                viewConstructors =
                    constructors
                        |> List.map
                            (\( cname, cparams ) ->
                                let
                                    cparams_ =
                                        cparams
                                            |> List.map (\param -> recurse param)
                                in
                                "| " ++ cname ++ String.join " " cparams_
                            )
                        |> String.join " "
            in
            "type " ++ name ++ viewConstructors

        TRecord name params fields ->
            let
                viewFields =
                    fields
                        |> List.map
                            (\( fname, ttype ) ->
                                fname ++ ": " ++ recurse ttype
                            )
                        |> String.join ("\n" ++ i ++ ", ")
            in
            case name of
                "Unknown" ->
                    "\n" ++ i ++ "{ " ++ viewFields ++ "\n" ++ i ++ "}"

                _ ->
                    i ++ "type alias " ++ name ++ " {\n" ++ viewFields ++ "\n}"

        TParam name ->
            name

        TMaybe ttype ->
            "List" ++ recurse ttype

        TRecursive name ->
            name

        TUnimplemented ->
            "TUnimplemented"


typeRich stub =
    let
        estyle =
            [ paddingXY 5 2, Border.width 1 ]

        tstyle =
            [ Font.color orange, paddingXY 5 2, Border.width 1, Border.color white ]
    in
    case stub of
        TString ->
            el tstyle (text <| "String")

        TInt ->
            el tstyle (text <| "Int")

        TFloat ->
            el tstyle (text <| "Float")

        TBool ->
            el tstyle (text <| "Bool")

        TList ttype ->
            row (estyle ++ [ spacing 5 ])
                ([ el [ Font.color orange, alignTop ] (text <| "List") ] ++ [ typeRich ttype ])

        TCustom name params constructors ->
            let
                viewConstructors =
                    constructors
                        |> List.map
                            (\( cname, cparams ) ->
                                let
                                    cparams_ =
                                        cparams
                                            |> List.map (\param -> typeRich param)
                                in
                                row []
                                    ([ text <| "|", el [ Font.color orange ] <| text cname ] ++ cparams_)
                            )
            in
            column []
                ([ row [ spacing 5 ]
                    [ el [ Font.color purple ] <| text "type"
                    , el [ Font.color orange ] (text <| name) --++ " custom")
                    ]
                 ]
                    ++ viewConstructors
                )

        TRecord name params fields ->
            let
                viewFields =
                    fields
                        |> List.map
                            (\( fname, ttype ) ->
                                row [ padding 5, spacing 5 ]
                                    [ el [ alignTop ] <| text fname
                                    , el [ alignTop, Font.color purple ] <| text " : "
                                    , typeRich ttype
                                    ]
                            )
            in
            case name of
                "Unknown" ->
                    column []
                        ([ row [ spacing 5, padding 5 ]
                            [ el [ Font.color purple ] <| text "{"
                            ]
                         ]
                            ++ viewFields
                            ++ [ row [ spacing 5, padding 5 ] [ el [ Font.color purple ] <| text "}" ]
                               ]
                        )

                _ ->
                    column []
                        ([ row [ spacing 5, padding 5 ]
                            [ el [ Font.color purple ] <| text "type alias"
                            , el [ Font.color orange ] (text <| name) --++ " custom")
                            ]
                         ]
                            ++ viewFields
                        )

        TParam name ->
            el [ Font.color red ] <| text name

        TMaybe ttype ->
            row (estyle ++ [ spacing 5 ])
                ([ el [ Font.color orange ] (text <| "Maybe") ] ++ [ typeRich ttype ])

        TRecursive name ->
            el [ Font.color orange ] <| text name

        TUnimplemented ->
            el [ Font.color red ] <| text "TUnimplemented"
