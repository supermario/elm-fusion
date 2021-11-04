module Curl exposing (runCurl)

import Cli.Option as Option
import Cli.OptionsParser as OptionsParser exposing (OptionsParser)
import Cli.OptionsParser.BuilderState
import Cli.OptionsParser.MatchResult exposing (MatchResult(..))
import Dict
import InterpolatedField
import Maybe.Extra
import Regex exposing (Regex)
import Request exposing (Request)


argsRegex : Regex
argsRegex =
    -- \s+|\s*'([^']*)'|\s*"([^"]*)"
    --"\\s+|\\s*'([^']*)'|\\s*\"([^\"]*)\""
    "\\s+|\\s*'([^']*)'|\\s*\"([^\"]*)\"|(\\S+)"
        --"\"[^\"\\\\]*(?:\\\\[\\S\\s][^\"\\\\]*)*\"|'[^'\\\\]*(?:\\[\\S\\s][^'\\]*)*'"
        -- source: https://stackoverflow.com/a/43766456
        --"\"([^\"\\\\]*(?:\\\\[\\S\\s][^\"\\]*)*)\"|'([^'\\]*(?:\\[\\S\\s][^'\\]*)*)'"
        |> regex


replaceEscapedNewlines : String -> String
replaceEscapedNewlines string =
    string
        |> String.replace "\\\n" " "


runCurl : String -> MatchResult Request
runCurl command =
    OptionsParser.tryMatch
        (command
            |> replaceEscapedNewlines
            |> Regex.find argsRegex
            |> List.map
                (\match ->
                    match.submatches
                        |> List.head
                        |> Maybe.withDefault Nothing
                        |> Maybe.withDefault match.match
                )
            |> List.filter
                (\arg ->
                    arg
                        |> Regex.contains (regex "^\\s*$")
                        |> not
                )
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
        (\url data compressed header headers2 user1 user2 method1 method2 ->
            let
                headers : Dict.Dict String String
                headers =
                    (header ++ headers2)
                        |> List.map splitHeader
                        |> Dict.fromList
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
                    Request.Empty

                else
                    let
                        contentType : String
                        contentType =
                            headers
                                |> Dict.get "Content-Type"
                                |> Maybe.withDefault "application/x-www-form-urlencoded"
                    in
                    data
                        |> String.join "\n"
                        |> Request.StringBody
                            -- TODO handle content-type's besides JSON
                            contentType
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
        |> OptionsParser.with (Option.flag "compressed")
        |> OptionsParser.with (Option.keywordArgList "header")
        |> OptionsParser.with (Option.keywordArgList "H")
        |> OptionsParser.with (Option.optionalKeywordArg "u")
        |> OptionsParser.with (Option.optionalKeywordArg "user")
        |> OptionsParser.with (Option.optionalKeywordArg "X")
        |> OptionsParser.with (Option.optionalKeywordArg "request")
        |> OptionsParser.end
