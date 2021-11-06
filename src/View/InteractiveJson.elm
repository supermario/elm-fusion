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
            column [ spacing 10 ]
                [ button [] (JsonAddAll parents jv) "Add all"
                , fields
                    |> List.map
                        (\( field, subJv ) ->
                            row
                                [ onWithoutPropagation "click" <| JsonAddField parents field subJv
                                , pointer
                                ]
                                [ el [ alignTop, mouseOver [ Background.color grey ] ] <| text <| field ++ ": "
                                , el [ width fill, onWithoutPropagation "click" NoOpFrontendMsg ] <| viewJsonValue (parents ++ [ field ]) subJv
                                ]
                        )
                    |> column [ spacing 10 ]
                ]
