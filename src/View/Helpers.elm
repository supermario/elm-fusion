module View.Helpers exposing (..)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Icon


button attrs msg label =
    el
        ([ Background.color grey
         , padding 10
         , onClick msg
         , pointer
         ]
            ++ attrs
        )
        (text
            label
        )


buttonHilightOn cond attrs msg t =
    let
        hilight =
            Background.color blue
    in
    if cond then
        button (attrs ++ [ hilight ]) msg t

    else
        button (attrs ++ []) msg t


buttonSvg getSvg attrs msg label =
    row
        ([ Background.color grey
         , padding 10
         , spacing 10
         , onClick msg
         , pointer
         ]
            ++ attrs
        )
        [ text label
        , Icon.icons |> getSvg
        ]


buttonHilightOnSvg getSvg cond attrs msg t =
    let
        hilight =
            Background.color blue
    in
    if cond then
        buttonSvg getSvg (attrs ++ [ hilight ]) msg t

    else
        buttonSvg getSvg (attrs ++ []) msg t


viewLabel label =
    el
        [ Background.color <| fromHex "325d76"
        , Font.color <| fromHex "#FFF"
        , Border.rounded 5
        , padding 4
        ]
    <|
        text label.label


heading string =
    el [ Font.size 20, Font.bold ] <| text string
