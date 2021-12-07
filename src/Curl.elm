module Curl exposing (runCurl)

import Cli.Option as Option
import Cli.OptionsParser as OptionsParser exposing (OptionsParser)
import Cli.OptionsParser.BuilderState
import Cli.OptionsParser.MatchResult exposing (MatchResult(..))
import CliArgsParser
import Dict.CaseInsensitive as Dict exposing (Dict)
import Fusion.Types
import InterpolatedField
import Maybe.Extra
import Parser
import Regex exposing (Regex)
import Request exposing (Request)


runCurl : String -> MatchResult Request
runCurl command =
    OptionsParser.tryMatch
        (command
            |> Parser.run CliArgsParser.parser
            |> Result.withDefault []
        )
        curl


regex : String -> Regex
regex string =
    Regex.fromString string |> Maybe.withDefault Regex.never


splitHeader : String -> ( String, String )
splitHeader header =
    let
        index : Int
        index =
            header
                |> String.indexes ":"
                |> List.head
                |> Maybe.withDefault 0
    in
    ( String.left index header
    , String.dropLeft (index + 1) header
        |> removeLeadingSpace
    )


removeLeadingSpace : String -> String
removeLeadingSpace string =
    Regex.replace (regex "^\\s*") (\value -> "") string


curl : OptionsParser Request Cli.OptionsParser.BuilderState.NoMoreOptions
curl =
    OptionsParser.build
        (\url data_ dataRaw compressed header headers2 user1 user2 method1 method2 ->
            let
                data =
                    data_ ++ dataRaw

                fullHeaders : Dict String
                fullHeaders =
                    (header ++ headers2)
                        |> List.map splitHeader
                        |> Dict.fromList

                headers =
                    fullHeaders
                        |> Dict.filter (\key value -> key /= "content-type")

                -- remove content-type
            in
            { url = url |> InterpolatedField.fromString
            , method =
                if data == [] then
                    Maybe.Extra.or method1 method2
                        |> Maybe.map
                            (\justMethod ->
                                case justMethod |> String.toUpper of
                                    "GET" ->
                                        Request.GET

                                    "POST" ->
                                        Request.POST

                                    _ ->
                                        Request.GET
                            )
                        |> Maybe.withDefault
                            Request.GET

                else
                    Request.POST
            , headers =
                headers
                    |> Dict.toList
                    |> List.map
                        (\( key, value ) ->
                            ( key |> InterpolatedField.fromString
                            , value |> InterpolatedField.fromString
                            )
                        )
            , body =
                if data == [] then
                    Fusion.Types.Empty

                else
                    let
                        contentType : String
                        contentType =
                            fullHeaders
                                |> Dict.get "content-type"
                                |> Maybe.withDefault "application/json"
                    in
                    if contentType == "application/json" then
                        data
                            |> String.join "\n"
                            |> Fusion.Types.JsonBody

                    else
                        data
                            |> String.join "\n"
                            |> Fusion.Types.StringBody contentType
            , timeout = Nothing
            , auth =
                Maybe.Extra.or user2 user1
                    |> Maybe.andThen
                        (\basicAuthString ->
                            case basicAuthString |> String.split ":" of
                                [ username, password ] ->
                                    Request.BasicAuth
                                        { username = username |> InterpolatedField.fromString
                                        , password = password |> InterpolatedField.fromString
                                        }
                                        |> Just

                                _ ->
                                    Nothing
                        )
            }
        )
        |> OptionsParser.with (Option.requiredPositionalArg "url")
        |> OptionsParser.with (Option.keywordArgList "data")
        |> OptionsParser.with (Option.keywordArgList "data-raw")
        |> OptionsParser.with (Option.flag "compressed")
        |> OptionsParser.with (Option.keywordArgList "header")
        |> OptionsParser.with (Option.keywordArgList "H")
        |> OptionsParser.with (Option.optionalKeywordArg "u")
        |> OptionsParser.with (Option.optionalKeywordArg "user")
        |> OptionsParser.with (Option.optionalKeywordArg "X")
        |> OptionsParser.with (Option.optionalKeywordArg "request")
        |> OptionsParser.end
