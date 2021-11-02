module Curl exposing (runCurl)

import Cli.Option as Option
import Cli.OptionsParser as OptionsParser exposing (OptionsParser)
import Cli.OptionsParser.BuilderState
import Cli.OptionsParser.MatchResult exposing (MatchResult(..))
import Dict
import Fusion.Types exposing (Request)
import Http
import Regex exposing (Regex)


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


runCurl : String -> MatchResult ( List ( String, String ), Request )
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


curl : OptionsParser ( List ( String, String ), Request ) Cli.OptionsParser.BuilderState.NoMoreOptions
curl =
    OptionsParser.build
        (\url data compressed header headers2 ->
            let
                headers : Dict.Dict String String
                headers =
                    (header ++ headers2)
                        |> List.map splitHeader
                        |> Dict.fromList
            in
            ( headers |> Dict.toList
            , { url = url
              , method =
                    if data == [] then
                        Fusion.Types.GET

                    else
                        Fusion.Types.POST
              , headers =
                    headers
                        |> Dict.toList
                        |> List.map (\( key, value ) -> Http.header key value)
              , body =
                    if data == [] then
                        Fusion.Types.Empty

                    else
                        let
                            contentType : String
                            contentType =
                                headers
                                    |> Dict.get "Content-Type"
                                    |> Debug.log "Content-Type"
                                    |> Maybe.withDefault "application/x-www-form-urlencoded"
                        in
                        data
                            |> String.join "\n"
                            |> Fusion.Types.StringBody
                                -- TODO handle content-type's besides JSON
                                contentType
              , timeout = Nothing
              }
            )
        )
        |> OptionsParser.with (Option.requiredPositionalArg "url")
        |> OptionsParser.with (Option.keywordArgList "data")
        |> OptionsParser.with (Option.flag "compressed")
        |> OptionsParser.with (Option.keywordArgList "header")
        |> OptionsParser.with (Option.keywordArgList "H")
        |> OptionsParser.end