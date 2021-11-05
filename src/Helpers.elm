module Helpers exposing (..)

import Element exposing (..)
import Html.Events
import Http
import Json.Decode as D
import Regex


log l v =
    -- Debug.log l v
    v


todo l v =
    -- Debug.todo l
    let
        _ =
            log ("Unimplemented: " ++ l) v
    in
    v


toString v =
    -- Debug.toString v
    "<toString neutered>"


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


onWithoutPropagation : String -> msg -> Attribute msg
onWithoutPropagation event msg =
    htmlAttribute <| Html.Events.stopPropagationOn event (D.succeed ( msg, True ))


padding_ t r b l =
    paddingEach { top = t, right = r, bottom = b, left = l }
