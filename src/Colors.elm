module Colors exposing (..)

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


orange =
    fromHex "#d19a66"


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
