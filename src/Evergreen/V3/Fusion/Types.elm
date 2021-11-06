module Evergreen.V3.Fusion.Types exposing (..)


type JsonPath
    = Root
    | At (List String) String


type alias Name =
    String


type alias MParams =
    List MType


type MType
    = MInt JsonPath
    | MFloat JsonPath
    | MString JsonPath
    | MBool JsonPath
    | MList MType JsonPath
    | MCustom Name MParams (List ( Name, List MType )) JsonPath
    | MRecord Name MParams (List ( Name, MType )) JsonPath
    | MParam Name
    | MMaybe MType JsonPath
    | MRecursive Name
    | MUnimplemented


type FusionDecoder
    = EmptyDecoder
    | FusionType MType


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
