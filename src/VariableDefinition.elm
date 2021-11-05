module VariableDefinition exposing (VariableDefinition(..), Visibility(..), default, visibility)


default : VariableDefinition
default =
    VariableDefinition "" Secret


type VariableDefinition
    = VariableDefinition String Visibility


type Visibility
    = Secret
    | Parameter


visibility : VariableDefinition -> Visibility
visibility (VariableDefinition _ visibility_) =
    visibility_
