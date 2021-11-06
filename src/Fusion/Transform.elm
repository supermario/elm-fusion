module Fusion.Transform exposing (..)

import Fusion.Types exposing (..)


mapToType : MType -> TType
mapToType mType =
    case mType of
        MInt _ ->
            TInt

        MFloat _ ->
            TFloat

        MString _ ->
            TString

        MBool _ ->
            TBool

        MList mType_ _ ->
            TList (mapToType mType_)

        MCustom name params variants _ ->
            TCustom name (List.map mapToType params) (List.map (\( l, v ) -> ( l, List.map mapToType v )) variants)

        MRecord name params fields _ ->
            TRecord name (List.map mapToType params) (List.map (\( l, v ) -> ( l, mapToType v )) fields)

        MParam name ->
            TParam name

        MMaybe mType_ _ ->
            TMaybe (mapToType mType_)

        MRecursive name ->
            TRecursive name

        MUnimplemented ->
            TUnimplemented


decoderToMType : FusionDecoder -> MType
decoderToMType decoder =
    case decoder of
        EmptyDecoder ->
            MUnimplemented

        FusionType mType ->
            mType
