module View.DecodePreview exposing (..)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Fusion.Json
import Fusion.Transform
import Fusion.Types exposing (..)
import Helpers exposing (..)
import Json.Decode as D
import Transform
import Types exposing (..)
import View.Helpers exposing (..)


view : VType -> Element msg
view vtype =
    -- text "ok"
    -- viewType : Maybe (Actions msg) -> VType -> Element msg
    -- viewType mActions t =
    let
        debug =
            -- [ Border.width 1, Border.color blue, width fill ]
            [ width fill ]
    in
    row [ spacing 10, Font.family [ Font.monospace ], width fill ]
        [ el debug <| typeRich vtype
        ]


typeRich : VType -> Element msg
typeRich vtype_ =
    let
        debug =
            -- Border.width 1
            attrNone

        estyle =
            [ debug ]

        tstyle =
            [ Font.color orange, debug, Border.color white ]

        recurse =
            typeRich

        -- withActions fn =
        --     mActions |> Maybe.map fn |> Maybe.withDefault attrNone
    in
    case vtype_ of
        VString jp ->
            el tstyle (text <| "String")

        VInt jp ->
            el tstyle (text <| "Int")

        VFloat jp ->
            el tstyle (text <| "Float")

        VBool jp ->
            el tstyle (text <| "Bool")

        VList ttype vtype ->
            -- row (estyle ++ [ spacing 5 ])
            --     ([ el [ Font.color orange, alignTop ] (text <| "List") ] ++ [ recurse vtype ])
            el tstyle (text <| "LIst")

        VCustom name params constructors ->
            let
                viewConstructors =
                    constructors
                        |> List.map
                            (\( cname, mparams, cparams ) ->
                                let
                                    cparams_ =
                                        cparams
                                            |> List.map (\param -> recurse param)
                                in
                                row []
                                    ([ text <| "|", el [ Font.color orange ] <| text cname ] ++ cparams_)
                            )
            in
            column [ spacing 5 ]
                ([ row [ spacing 5 ]
                    [ el [ Font.color purple ] <| text "type"
                    , el [ Font.color orange ] (text <| name) --++ " custom")
                    ]
                 ]
                    ++ viewConstructors
                )

        VRecord name params fields ->
            let
                viewFields =
                    fields
                        |> List.map
                            (\( fname, mtype, vtype ) ->
                                if simpleEnoughForSingleLine vtype then
                                    row
                                        [ padding 5
                                        , spacing 0
                                        , padding_ 0 0 0 20

                                        -- , withActions (\actions -> inFront (Icon.icons.delete [ Font.color grey, onClick (actions.delete vtype), pointer ]))
                                        , width fill
                                        ]
                                        [ el [ alignTop ] <| text fname
                                        , el [ alignTop, Font.color purple ] <| text " = "
                                        , let
                                            isLeaf =
                                                isleafType vtype

                                            -- _ =
                                            --     Debug.log "isLeaf" ( isLeaf, vtype )
                                          in
                                          if isLeaf then
                                            extractValue vtype

                                          else
                                            recurse vtype
                                        ]

                                else
                                    column
                                        [ padding 5
                                        , spacing 5
                                        , padding_ 0 0 0 20

                                        -- , withActions (\actions -> inFront (Icon.icons.delete [ Font.color grey, onClick (actions.delete vtype), pointer ]))
                                        , width fill
                                        ]
                                        [ row []
                                            [ el [ alignTop ] <| text fname
                                            , el [ alignTop, Font.color purple ] <| text " : "
                                            ]
                                        , recurse vtype
                                        ]
                            )
            in
            case name of
                "Unknown" ->
                    column [ width fill, spacing 5 ]
                        ([ el [ Font.color purple ] <| text "{"
                         ]
                            ++ viewFields
                            ++ [ el [ Font.color purple ] <| text "}"
                               ]
                        )

                _ ->
                    column [ width fill, spacing 5 ]
                        ([ row [ spacing 5, padding 5, width fill ]
                            [ el [ Font.color purple ] <| text "type alias"
                            , el [ Font.color orange ] (text <| name) --++ " custom")
                            ]
                         ]
                            ++ viewFields
                        )

        VParam name ->
            el [ Font.color red ] <| text name

        VMaybe mtype vtype ->
            row (estyle ++ [ spacing 5 ])
                -- ([ el [ Font.color orange ] (text <| "Maybe") ] ++ [ recurse vtype ])
                ([ el [ Font.color orange ] (text <| "Maybe") ] ++ [ text "TODO typeRich VMaybe" ])

        VRecursive name ->
            el [ Font.color orange ] <| text name

        VUnimplemented ->
            el [ Font.color red ] <| text "TUnimplemented"

        VError s ->
            el [ Font.color red ] <| text <| "Error: " ++ s


simpleEnoughForSingleLine : VType -> Bool
simpleEnoughForSingleLine ttype =
    case ttype of
        VRecord name params fields ->
            False

        _ ->
            True


isleafType : VType -> Bool
isleafType vtype =
    let
        -- _ =
        --     Debug.log "isLeafType" ( vtype, Transform.children Fusion.Transform.recurseChildrenVType vtype )
        children =
            Transform.children Fusion.Transform.recurseChildrenVType vtype
    in
    List.length children <= 1


extractValue : VType -> Element msg
extractValue vtype =
    case vtype of
        VInt i ->
            orange_ <| String.fromInt i

        VFloat jp ->
            text ""

        VString s ->
            green_ <| "\"" ++ s ++ "\""

        VBool jp ->
            text ""

        VList mType_ jp ->
            -- fn mType_
            text <| todo "extractValue" "MList"

        VCustom name params variants ->
            -- List.map fn params ++ (List.map (\( l, v ) -> List.map fn v) variants |> List.concat) |> List.concat
            text <| todo "extractValue" "MCustom"

        VRecord name params fields ->
            -- List.map fn params ++ List.map (\( l, v ) -> fn v) fields |> List.concat
            text <| todo "extractValue" "MRecord"

        VParam name ->
            text ""

        VMaybe mType_ vtype_ ->
            case vtype_ of
                Just vtype__ ->
                    extractValue vtype__

                Nothing ->
                    el [ Font.color orange ] (text "Nothing")

        VRecursive name ->
            text ""

        VUnimplemented ->
            text ""

        VError s ->
            text <| "Error: " ++ s


green_ s =
    paragraph [ Font.color green ] [ text s ]


red_ s =
    paragraph [ Font.color red ] [ text s ]


orange_ s =
    paragraph [ Font.color orange ] [ text s ]
