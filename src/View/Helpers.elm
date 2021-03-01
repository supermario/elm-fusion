module View.Helpers exposing (..)

import Color exposing (rgb)
import Color.Convert exposing (hexToColor)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font


grey =
    fromHex "#eeeeee"


blue =
    fromHex "#5ba4e0"


purple =
    fromHex "#bd74d4"


green =
    fromHex "#98c379"


yellow =
    fromHex "#ffe59c"


red =
    fromHex "#ff9982"


charcoal =
    fromHex "#333"


darkGrey =
    fromHex "#aaa"


fromHex : String -> Color
fromHex str =
    case hexToColor str of
        Ok col ->
            let
                x =
                    Color.toRgba col
            in
            Element.rgba x.red x.green x.blue x.alpha

        Err _ ->
            Element.rgb 255 0 0


button attrs msg label =
    el
        ([ Background.color <| fromHex "#aaa"
         , padding 10
         , onClick msg
         , pointer
         ]
            ++ attrs
        )
        (text
            label
        )


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
