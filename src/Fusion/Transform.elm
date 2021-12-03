module Fusion.Transform exposing (..)

import Fusion.Json
import Fusion.Types exposing (..)
import Helpers exposing (..)
import Transform


recurseMType : (MType -> MType) -> MType -> MType
recurseMType fn mtype =
    case mtype of
        MInt jp ->
            MInt jp

        MFloat jp ->
            MFloat jp

        MString jp ->
            MString jp

        MBool jp ->
            MBool jp

        MList mType_ jp ->
            MList (fn mType_) jp

        MCustom name params variants jp ->
            MCustom name (List.map fn params) (List.map (\( l, v ) -> ( l, List.map fn v )) variants) jp

        MRecord name params fields jp ->
            MRecord name (List.map fn params) (List.map (\( l, v ) -> ( l, fn v )) fields) jp

        MParam name ->
            MParam name

        MMaybe mType_ jp ->
            MMaybe (fn mType_) jp

        MRecursive name ->
            MRecursive name

        MUnimplemented ->
            MUnimplemented


recurseChildrenMType : (MType -> List MType) -> MType -> List MType
recurseChildrenMType fn mtype =
    case mtype of
        MInt jp ->
            []

        MFloat jp ->
            []

        MString jp ->
            []

        MBool jp ->
            []

        MList mType_ jp ->
            fn mType_

        MCustom name params variants jp ->
            List.map fn params ++ (List.map (\( l, v ) -> List.map fn v) variants |> List.concat) |> List.concat

        MRecord name params fields jp ->
            List.map fn params ++ List.map (\( l, v ) -> fn v) fields |> List.concat

        MParam name ->
            []

        MMaybe mType_ jp ->
            fn mType_

        MRecursive name ->
            []

        MUnimplemented ->
            []


recurseChildrenVType : (VType -> List VType) -> VType -> List VType
recurseChildrenVType fn vtype =
    case vtype of
        VInt _ ->
            []

        VFloat _ ->
            []

        VString jp ->
            []

        VBool jp ->
            []

        VList mtype vtype_ ->
            List.map fn vtype_ |> List.concat

        VCustom name params variants ->
            (List.map (\( l, t, v ) -> List.map fn v) variants |> List.concat) |> List.concat

        VRecord name params fields ->
            List.map (\( l, t, v ) -> fn v) fields |> List.concat

        VParam name ->
            []

        VMaybe mType_ vtype_ ->
            case vtype_ of
                Just vtype__ ->
                    fn vtype__

                Nothing ->
                    []

        VRecursive name ->
            []

        VUnimplemented ->
            []

        VError s ->
            []


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


extractVType : MType -> JsonValue -> VType
extractVType mtype jv =
    case mtype of
        MInt jp ->
            case Fusion.Json.getValue jp jv of
                Just (JInt i) ->
                    VInt i

                Just x ->
                    VError <| "Debug.crash \"Unexpected value for mapped Int: " ++ Fusion.Json.jsonValueToString x ++ "\""

                Nothing ->
                    VError <| "Debug.crash \"Mapped value does not exist in source JSON."

        MFloat jp ->
            VError <| "extractVType unimplemented: MFloat"

        MString jp ->
            case Fusion.Json.getValue jp jv of
                Just (JString s) ->
                    VString s

                Just x ->
                    VError <| "Debug.crash \"Unexpected value for mapped String: " ++ Fusion.Json.jsonValueToString x ++ "\""

                Nothing ->
                    VError <| "Debug.crash \"Mapped value does not exist in source JSON."

        MBool jp ->
            VError <| "extractVType unimplemented: MBool"

        MList mType_ jp ->
            -- fn mType_
            VError <| "extractVType unimplemented: MList"

        MCustom name params variants jp ->
            -- List.map fn params ++ (List.map (\( l, v ) -> List.map fn v) variants |> List.concat) |> List.concat
            VError <| "extractVType unimplemented: MCustom"

        MRecord name params fields jp ->
            VRecord name params (fields |> List.map (\( n, m ) -> ( n, m, extractVType m jv )))

        -- List.map fn params ++ List.map (\( l, v ) -> fn v) fields |> List.concat
        -- VError <| "extractVType unimplemented: MRecord"
        MParam name ->
            VParam name

        MMaybe mtype_ jp ->
            case Fusion.Json.getValue jp jv of
                Just JNull ->
                    VMaybe mtype_ Nothing

                _ ->
                    VError <| "extractVType unimplemented case in MMaybe"

        MRecursive name ->
            VError <| "extractVType unimplemented: MRecursive"

        MUnimplemented ->
            VError <| "extractVType unimplemented: MUnimplemented"
