module Evergreen.V3.Request exposing (..)

import Evergreen.V3.InterpolatedField


type Method
    = GET
    | POST


type Body
    = Empty
    | StringBody String String


type Auth
    = BasicAuth
        { username : Evergreen.V3.InterpolatedField.InterpolatedField
        , password : Evergreen.V3.InterpolatedField.InterpolatedField
        }


type alias Request =
    { method : Method
    , headers : List ( Evergreen.V3.InterpolatedField.InterpolatedField, Evergreen.V3.InterpolatedField.InterpolatedField )
    , url : Evergreen.V3.InterpolatedField.InterpolatedField
    , body : Body
    , timeout : Maybe Float
    , auth : Maybe Auth
    }
