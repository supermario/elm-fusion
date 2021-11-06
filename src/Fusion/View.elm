module Fusion.View exposing (..)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Fusion.Types exposing (..)
import Icon
import Types exposing (..)
import View.Helpers exposing (..)


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


type alias Actions msg =
    { delete : MType -> msg }


viewType : Maybe (Actions msg) -> MType -> Element msg
viewType mActions t =
    let
        debug =
            -- [ Border.width 1, Border.color blue, width fill ]
            [ width fill ]
    in
    row [ spacing 10, Font.family [ Font.monospace ], width fill ]
        [ el debug <| typeRich mActions t
        ]


typeString : Int -> TType -> String
typeString indent stub =
    let
        recurse =
            typeString (indent + 1)

        i =
            String.repeat (indent * 4) " "
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
                                fname ++ " : " ++ recurse ttype
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
            "Maybe " ++ recurse ttype

        TRecursive name ->
            name

        TUnimplemented ->
            "TUnimplemented"


typeRich : Maybe (Actions msg) -> MType -> Element msg
typeRich mActions mtype_ =
    let
        debug =
            -- Border.width 1
            attrNone

        estyle =
            [ paddingXY 5 2, debug ]

        tstyle =
            [ Font.color orange, paddingXY 5 2, debug, Border.color white ]

        recurse =
            typeRich mActions

        withActions fn =
            mActions |> Maybe.map fn |> Maybe.withDefault attrNone
    in
    case mtype_ of
        MString jp ->
            el tstyle (text <| "String")

        MInt jp ->
            el tstyle (text <| "Int")

        MFloat jp ->
            el tstyle (text <| "Float")

        MBool jp ->
            el tstyle (text <| "Bool")

        MList ttype jp ->
            row (estyle ++ [ spacing 5 ])
                ([ el [ Font.color orange, alignTop ] (text <| "List") ] ++ [ recurse ttype ])

        MCustom name params constructors jp ->
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

        MRecord name params fields jp ->
            let
                viewFields =
                    fields
                        |> List.map
                            (\( fname, mtype ) ->
                                if simpleEnoughForSingleLine mtype then
                                    row
                                        [ padding 5
                                        , spacing 0
                                        , padding_ 0 0 0 20
                                        , withActions (\actions -> inFront (Icon.icons.delete [ Font.color grey, onClick (actions.delete mtype), pointer ]))
                                        , width fill
                                        ]
                                        [ el [ alignTop ] <| text fname
                                        , el [ alignTop, Font.color purple ] <| text " : "
                                        , recurse mtype
                                        ]

                                else
                                    column
                                        [ padding 5
                                        , spacing 0
                                        , padding_ 0 0 0 20
                                        , withActions (\actions -> inFront (Icon.icons.delete [ Font.color grey, onClick (actions.delete mtype), pointer ]))
                                        , width fill
                                        ]
                                        [ row []
                                            [ el [ alignTop ] <| text fname
                                            , el [ alignTop, Font.color purple ] <| text " : "
                                            ]
                                        , recurse mtype
                                        ]
                            )
            in
            case name of
                "Unknown" ->
                    column [ width fill ]
                        ([ row [ spacing 5, padding 5, width fill ]
                            [ el [ Font.color purple ] <| text "{"
                            ]
                         ]
                            ++ viewFields
                            ++ [ row [ spacing 5, padding 5, width fill ] [ el [ Font.color purple ] <| text "}" ]
                               ]
                        )

                _ ->
                    column [ width fill ]
                        ([ row [ spacing 5, padding 5, width fill ]
                            [ el [ Font.color purple ] <| text "type alias"
                            , el [ Font.color orange ] (text <| name) --++ " custom")
                            ]
                         ]
                            ++ viewFields
                        )

        MParam name ->
            el [ Font.color red ] <| text name

        MMaybe mtype jp ->
            row (estyle ++ [ spacing 5 ])
                ([ el [ Font.color orange ] (text <| "Maybe") ] ++ [ recurse mtype ])

        MRecursive name ->
            el [ Font.color orange ] <| text name

        MUnimplemented ->
            el [ Font.color red ] <| text "TUnimplemented"


simpleEnoughForSingleLine : MType -> Bool
simpleEnoughForSingleLine ttype =
    case ttype of
        MRecord name params fields jp ->
            False

        _ ->
            True
