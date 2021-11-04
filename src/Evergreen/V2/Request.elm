module Evergreen.V2.Request exposing (..)

import Evergreen.V2.InterpolatedField


type Method
    = GET
    | POST


type Body
    = Empty
    | StringBody String String


type alias Request =
    { method : Method
    , headers : List ( Evergreen.V2.InterpolatedField.InterpolatedField, Evergreen.V2.InterpolatedField.InterpolatedField )
    , url : String
    , body : Body
    , timeout : Maybe Float
    }
