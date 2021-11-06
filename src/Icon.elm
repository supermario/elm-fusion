module Icon exposing (icons)

import Element exposing (Attribute, Element)
import FeatherIcons
import Html exposing (Html)


icons :
    { visible : List (Attribute msg) -> Element msg
    , notVisible : List (Attribute msg) -> Element msg
    , delete : List (Attribute msg) -> Element msg
    }
icons =
    { visible = standard FeatherIcons.eye
    , notVisible = standard FeatherIcons.eyeOff
    , delete = standard FeatherIcons.trash
    }


standard : FeatherIcons.Icon -> List (Attribute msg) -> Element msg
standard icon attr =
    toElement (icon |> FeatherIcons.withSize 14) attr


toElement : FeatherIcons.Icon -> List (Attribute msg) -> Element msg
toElement icon attrs =
    icon
        |> FeatherIcons.toHtml []
        |> Element.html
        |> Element.el attrs
