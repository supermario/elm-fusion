module Evergreen.V2.Fusion.Types exposing (..)


type alias Name =
    String


type alias TParams =
    List TType


type TType
    = TInt
    | TFloat
    | TString
    | TBool
    | TList TType
    | TCustom Name TParams (List ( Name, List TType ))
    | TRecord Name TParams (List ( Name, TType ))
    | TParam Name
    | TMaybe TType
    | TRecursive Name
    | TUnimplemented


type FusionDecoder
    = EmptyDecoder
    | FusionType TType


type HttpError
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Int String
    | BadBody String


type JsonValue
    = JInt Int
    | JFloat Float
    | JString String
    | JBool Bool
    | JNull
    | JList (List JsonValue)
    | JObject (List ( String, JsonValue ))
