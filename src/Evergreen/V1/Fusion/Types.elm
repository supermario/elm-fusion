module Evergreen.V1.Fusion.Types exposing (..)

import Http


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


type RequestMethod
    = GET
    | POST


type RequestBodyPart
    = StringPart
    | FilePart
    | BytesPart


type RequestBody
    = Empty
    | StringBody String String
    | Json
    | File
    | Bytes
    | MultiPart (List RequestBodyPart)


type alias Request =
    { method : RequestMethod
    , headers : List Http.Header
    , url : String
    , body : RequestBody
    , timeout : Maybe Float
    }


type JsonValue
    = JInt Int
    | JFloat Float
    | JString String
    | JBool Bool
    | JNull
    | JList (List JsonValue)
    | JObject (List ( String, JsonValue ))
