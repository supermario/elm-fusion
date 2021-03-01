module Helpers exposing (..)

import Http
import Json.Decode as D
import Regex


justs =
    List.foldl
        (\v acc ->
            case v of
                Just el ->
                    [ el ] ++ acc

                Nothing ->
                    acc
        )
        []


jsonResolver : D.Decoder a -> Http.Resolver Http.Error a
jsonResolver decoder =
    Http.stringResolver <|
        \response ->
            case response of
                Http.GoodStatus_ _ body ->
                    D.decodeString decoder body
                        |> Result.mapError D.errorToString
                        |> Result.mapError Http.BadBody

                Http.BadUrl_ message ->
                    Err (Http.BadUrl message)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ metadata _ ->
                    Err (Http.BadStatus metadata.statusCode)


stringResolver : Http.Resolver Http.Error String
stringResolver =
    Http.stringResolver <|
        \response ->
            case response of
                Http.GoodStatus_ _ body ->
                    Ok body

                Http.BadUrl_ message ->
                    Err (Http.BadUrl message)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ metadata _ ->
                    Err (Http.BadStatus metadata.statusCode)


regexSubmatchFirst : String -> String -> Maybe String
regexSubmatchFirst regex string =
    let
        regex_ =
            regex
                |> Regex.fromString
                |> Maybe.withDefault Regex.never
                |> Regex.find
    in
    regex_ string
        |> List.head
        |> Maybe.map .submatches
        |> Maybe.andThen List.head
        |> (\v ->
                case v of
                    Just match ->
                        match

                    _ ->
                        Nothing
           )
