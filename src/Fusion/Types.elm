module Fusion.Types exposing (..)

import Http


type
    TType
    -- Type level type
    = TInt
    | TFloat
    | TString
    | TBool
    | TList TType
    | TCustom Name TParams (List ( Name, List TType ))
    | TRecord Name TParams (List ( Name, TType ))
      -- Helpers
    | TRecursive Name
      --
    | TUnimplemented


type alias Name =
    String


type alias TParams =
    List TType


type alias Request =
    { method : RequestMethod
    , headers : List Http.Header
    , url : String
    , body : RequestBody
    , timeout : Maybe Float
    }


type RequestMethod
    = GET
    | POST


type RequestBody
    = Empty
    | StringBody String String
    | Json
    | File
    | Bytes
    | MultiPart (List RequestBodyPart)


type RequestBodyPart
    = StringPart
    | FilePart
    | BytesPart


type alias FieldName =
    String


type FusionDecoder
    = EmptyDecoder
    | FusionType TType


type JsonValue
    = JInt Int
    | JFloat Float
    | JString String
    | JBool Bool
    | JNull
    | JList (List JsonValue)
    | JObject (List ( String, JsonValue ))
