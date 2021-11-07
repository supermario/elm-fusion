module Evergreen.V4.Request exposing (..)

import Evergreen.V4.InterpolatedField


type Method
    = GET
    | POST


type Body
    = Empty
    | StringBody String String


type Auth
    = BasicAuth
        { username : Evergreen.V4.InterpolatedField.InterpolatedField
        , password : Evergreen.V4.InterpolatedField.InterpolatedField
        }


type alias Request =
    { method : Method
    , headers : List ( Evergreen.V4.InterpolatedField.InterpolatedField, Evergreen.V4.InterpolatedField.InterpolatedField )
    , url : Evergreen.V4.InterpolatedField.InterpolatedField
    , body : Body
    , timeout : Maybe Float
    , auth : Maybe Auth
    }
