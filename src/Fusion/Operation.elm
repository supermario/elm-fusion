module Fusion.Operation exposing (..)

import Fusion.Types exposing (..)
import Helpers exposing (..)
import List.Extra as List


guessElmTypeForJsonValue : JsonValue -> JsonPath -> MType
guessElmTypeForJsonValue jv jsonPath =
    case jv of
        JInt int ->
            MInt jsonPath

        JFloat float ->
            MFloat jsonPath

        JString string ->
            MString jsonPath

        JBool bool ->
            MBool jsonPath

        JNull ->
            MMaybe (MParam "unknown") jsonPath

        JList jvs ->
            case jvs of
                v :: _ ->
                    -- @TODO this aint right
                    MList (guessElmTypeForJsonValue v jsonPath) jsonPath

                [] ->
                    MList (MParam "unknown") jsonPath

        JObject fields ->
            let
                fieldPath name =
                    case jsonPath of
                        Root ->
                            At [] name

                        At parents field ->
                            At (parents ++ [ field ]) name
            in
            fields
                |> List.map (\( name, jv_ ) -> ( name, guessElmTypeForJsonValue jv_ (fieldPath name) ))
                |> (\fields_ -> MRecord "Unknown" [] fields_ jsonPath)


fusionAddField parents fieldName jv decoder =
    let
        x =
            log "fusionAddField" ( parents, fieldName, jv )
    in
    log "fusionAddFieldResult" <|
        FusionType <|
            case decoder of
                EmptyDecoder ->
                    let
                        _ =
                            log "fusionAddField" ( "first field", fieldName )
                    in
                    mTypeAddField parents fieldName jv (MRecord "Unknown" [] [] Root)

                FusionType mtype ->
                    let
                        _ =
                            log "fusionAddField" ( "adding field", fieldName )
                    in
                    mTypeAddField parents fieldName jv mtype


fusionAddAll : List String -> JsonValue -> Fusion.Types.FusionDecoder -> Fusion.Types.FusionDecoder
fusionAddAll parents jv decoder =
    log "fusionAddAll" <|
        case jv of
            JObject fields ->
                fields
                    |> List.foldl
                        (\( f, v ) d ->
                            -- let
                            --     x =
                            --         log ("jv for field: " ++ f) v
                            --
                            -- in
                            fusionAddField parents f v d
                        )
                        decoder

            _ ->
                let
                    _ =
                        todo <| "todo JsonAddAll" ++ toString ( parents, jv )
                in
                decoder


fusionRemove mtype decoder =
    let
        x =
            log "fusionRemove" mtype
    in
    log "fusionRemoveResult" <|
        case decoder of
            EmptyDecoder ->
                FusionType <| mtype

            FusionType mtype_ ->
                if mtype == mtype_ then
                    EmptyDecoder

                else
                    FusionType <| mTypeRemove mtype mtype_


mTypeAddField parents fieldName jv mtype =
    case mtype of
        MRecord name tParams fields jsonPath ->
            if List.find (\( f, t ) -> f == fieldName) fields == Nothing then
                case parents of
                    [] ->
                        let
                            _ =
                                log "mTypeAddField" "0 parents, appending field"
                        in
                        MRecord name
                            tParams
                            (List.append fields [ ( fieldName, guessElmTypeForJsonValue jv (At parents fieldName) ) ]
                                |> List.uniqueBy (\( n, f ) -> n)
                            )
                            jsonPath

                    p :: ps ->
                        let
                            _ =
                                log "mTypeAddField" ("parent " ++ p ++ " upserting field")
                        in
                        MRecord name
                            tParams
                            (fields
                                |> onRecordField p (\( n, mtype_ ) -> ( n, mTypeAddField ps fieldName jv mtype_ ))
                            )
                            jsonPath

            else
                let
                    _ =
                        log "mTypeAddField" "field already exists"
                in
                -- Nothing to add
                mtype

        _ ->
            let
                _ =
                    log "mTypeAddField" "cannot add to non-record type"
            in
            -- Cannot add fields to non-record type
            mtype


mTypeRemove : MType -> MType -> MType
mTypeRemove mtype target =
    let
        _ =
            log "mTypeRemoving" ( mtype, target )
    in
    case target of
        MRecord name tParams fields jsonPath ->
            fields
                |> List.filterMap
                    (\( n, subType ) ->
                        if subType == mtype then
                            Nothing

                        else
                            Just <| ( n, mTypeRemove mtype subType )
                    )
                |> (\newFields -> MRecord name tParams newFields jsonPath)

        _ ->
            target


onRecordField fieldName fn fields =
    case List.find (\( f, t ) -> f == fieldName) fields of
        Just _ ->
            fields
                |> List.updateIf (\( f, t ) -> f == fieldName) fn

        Nothing ->
            List.append fields [ fn ( fieldName, MRecord "Unknown" [] [] Root ) ]
