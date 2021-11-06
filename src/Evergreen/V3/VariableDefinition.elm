module Evergreen.V3.VariableDefinition exposing (..)


type Visibility
    = Secret
    | Parameter


type VariableDefinition
    = VariableDefinition String Visibility
