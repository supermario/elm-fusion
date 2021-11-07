module Evergreen.V4.VariableDefinition exposing (..)


type Visibility
    = Secret
    | Parameter


type VariableDefinition
    = VariableDefinition String Visibility
