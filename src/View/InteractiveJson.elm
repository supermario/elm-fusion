module View.InteractiveJson exposing (..)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Fusion.Types exposing (..)
import Helpers exposing (..)
import Types exposing (..)
import View.Helpers exposing (..)


fromJsonValue parents jsonValue =
    el [ width fill, Font.family [ Font.monospace ], alignTop ] <|
        viewJsonValue [] jsonValue


viewJsonValue parents jv =
    case jv of
        JInt int ->
            paragraph [ Font.color orange ] [ text <| String.fromInt int ]

        JFloat float ->
            paragraph [ Font.color orange ] [ text <| String.fromFloat float ]

        JString string ->
            paragraph [ Font.color green, width (fill |> maximum 300) ] [ text <| "\"" ++ string ++ "\"" ]

        JBool bool ->
            text <|
                case bool of
                    True ->
                        "true"

                    False ->
                        "false"

        JNull ->
            text "null"

        JList list ->
            list
                |> List.map (viewJsonValue parents)
                -- |> List.intersperse (text ",")
                |> column [ spacing 10 ]

        JObject fields ->
            column [ spacing 5 ]
                [ row [ spacing 10 ]
                    [ text "{"
                    , button [ Font.size 10, padding 2 ] (JsonAddAll parents jv) "Add all"
                    ]
                , fields
                    |> List.map
                        (\( field, subJv ) ->
                            if simpleEnoughForSingleLine subJv then
                                row
                                    [ onWithoutPropagation "click" <| JsonAddField parents field subJv
                                    , pointer
                                    ]
                                    [ el [ alignTop, mouseOver [ Background.color grey ] ] <| text <| field ++ " : "
                                    , el [ width fill, onWithoutPropagation "click" NoOpFrontendMsg ] <|
                                        viewJsonValue (parents ++ [ field ]) subJv
                                    ]

                            else
                                column
                                    [ onWithoutPropagation "click" <| JsonAddField parents field subJv
                                    , pointer
                                    , spacing 10
                                    ]
                                    [ el [ alignTop, mouseOver [ Background.color grey ] ] <| text <| field ++ " : "
                                    , el [ width fill, onWithoutPropagation "click" NoOpFrontendMsg, padding_ 0 0 0 20 ] <|
                                        viewJsonValue (parents ++ [ field ]) subJv
                                    ]
                        )
                    |> column [ spacing 5, padding_ 0 0 0 20 ]
                , text "}"
                ]


simpleEnoughForSingleLine jv =
    not (isRecord jv)


isRecord jv =
    case jv of
        JObject _ ->
            True

        _ ->
            False
