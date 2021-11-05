module Fusion.Types exposing (..)

import Http


{-| Mapped type
-}
type MType
    = MInt JsonPath
    | MFloat JsonPath
    | MString JsonPath
    | MBool JsonPath
    | MList MType JsonPath
    | MCustom Name MParams (List ( Name, List MType )) JsonPath
    | MRecord Name MParams (List ( Name, MType )) JsonPath
    | MParam Name
      -- Non-language but core types
    | MMaybe MType JsonPath
      -- Helpers
    | MRecursive Name
      --
    | MUnimplemented


type alias MParams =
    List MType


type JsonPath
    = Root
    | At (List String) String


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
    | TParam Name
      -- Non-language but core types
    | TMaybe TType
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
    | FusionType MType


type JsonValue
    = JInt Int
    | JFloat Float
    | JString String
    | JBool Bool
    | JNull
    | JList (List JsonValue)
    | JObject (List ( String, JsonValue ))


type HttpError
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Int String
    | BadBody String
