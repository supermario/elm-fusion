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


view : JsonValue -> MType -> Element msg
view jv mtype =
    -- text "ok"
    -- viewType : Maybe (Actions msg) -> MType -> Element msg
    -- viewType mActions t =
    let
        debug =
            -- [ Border.width 1, Border.color blue, width fill ]
            [ width fill ]
    in
    row [ spacing 10, Font.family [ Font.monospace ], width fill ]
        [ el debug <| typeRich jv mtype
        ]


typeRich : JsonValue -> MType -> Element msg
typeRich jv mtype_ =
    let
        debug =
            -- Border.width 1
            attrNone

        estyle =
            [ paddingXY 5 2, debug ]

        tstyle =
            [ Font.color orange, paddingXY 5 2, debug, Border.color white ]

        recurse =
            typeRich jv

        -- withActions fn =
        --     mActions |> Maybe.map fn |> Maybe.withDefault attrNone
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

                                        -- , withActions (\actions -> inFront (Icon.icons.delete [ Font.color grey, onClick (actions.delete mtype), pointer ]))
                                        , width fill
                                        ]
                                        [ el [ alignTop ] <| text fname
                                        , el [ alignTop, Font.color purple ] <| text " = "
                                        , let
                                            isLeaf =
                                                isleafType mtype

                                            -- _ =
                                            --     Debug.log "isLeaf" ( isLeaf, mtype )
                                          in
                                          if isLeaf then
                                            attemptExtractValue jv mtype

                                          else
                                            recurse mtype
                                        ]

                                else
                                    column
                                        [ padding 5
                                        , spacing 0
                                        , padding_ 0 0 0 20

                                        -- , withActions (\actions -> inFront (Icon.icons.delete [ Font.color grey, onClick (actions.delete mtype), pointer ]))
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


isleafType : MType -> Bool
isleafType mtype =
    let
        -- _ =
        --     Debug.log "isLeafType" ( mtype, Transform.children Fusion.Transform.recurseChildrenMType mtype )
        children =
            Transform.children Fusion.Transform.recurseChildrenMType mtype
    in
    List.length children <= 1


attemptExtractValue : JsonValue -> MType -> Element msg
attemptExtractValue jv mtype =
    case mtype of
        MInt jp ->
            case Fusion.Json.getValue jp jv of
                Just (JInt i) ->
                    orange_ <| String.fromInt i

                Just x ->
                    red_ <| "Debug.crash \"Unexpected value for mapped Int: " ++ Fusion.Json.jsonValueToString x ++ "\""

                Nothing ->
                    red_ <| "Debug.crash \"Mapped value does not exist in source JSON."

        MFloat jp ->
            text ""

        MString jp ->
            case Fusion.Json.getValue jp jv of
                Just (JString s) ->
                    green_ <| "\"" ++ s ++ "\""

                Just x ->
                    red_ <| "Debug.crash \"Unexpected value for mapped String: " ++ Fusion.Json.jsonValueToString x ++ "\""

                Nothing ->
                    red_ <| "Debug.crash \"Mapped value does not exist in source JSON."

        MBool jp ->
            text ""

        MList mType_ jp ->
            -- fn mType_
            Debug.todo "attemptExtractValue MList"

        MCustom name params variants jp ->
            -- List.map fn params ++ (List.map (\( l, v ) -> List.map fn v) variants |> List.concat) |> List.concat
            Debug.todo "attemptExtractValue MCustom"

        MRecord name params fields jp ->
            -- List.map fn params ++ List.map (\( l, v ) -> fn v) fields |> List.concat
            Debug.todo "attemptExtractValue MRecord"

        MParam name ->
            text ""

        MMaybe mType_ jp ->
            attemptExtractValue jv mType_

        MRecursive name ->
            text ""

        MUnimplemented ->
            text ""


green_ s =
    paragraph [ Font.color green ] [ text s ]


red_ s =
    paragraph [ Font.color red ] [ text s ]


orange_ s =
    paragraph [ Font.color orange ] [ text s ]
