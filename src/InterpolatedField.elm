module InterpolatedField exposing (Content(..), InterpolatedField(..), InterpolationField(..), Variable(..), fieldParser, fromString, interpolate, interpolationField, statementsHelp, toElmString, toString, tokenParser)

import Dict exposing (Dict)
import Parser exposing ((|.), (|=), Parser)
import String.Extra


type InterpolatedField
    = InterpolatedField String


interpolate : Dict String String -> InterpolatedField -> String
interpolate interpolationValues (InterpolatedField raw) =
    case Parser.run fieldParser raw of
        Ok parsed ->
            parsed
                |> List.map
                    (\text ->
                        case text of
                            RawText rawText ->
                                rawText

                            InterpolatedText (Variable variableName) ->
                                interpolationValues
                                    |> Dict.get variableName
                                    |> Maybe.withDefault ""
                    )
                |> String.join ""

        Err error ->
            "TODO"


fromString : String -> InterpolatedField
fromString string =
    InterpolatedField string


toString : InterpolatedField -> String
toString (InterpolatedField raw) =
    raw


tokenParser : Parser Variable
tokenParser =
    Parser.succeed Variable
        |. Parser.token "$"
        |= Parser.oneOf
            [ Parser.succeed identity
                |. Parser.token "{"
                |= (Parser.chompWhile (\character -> character /= ' ' && character /= '\n' && character /= '}')
                        |> Parser.getChompedString
                   )
                |. Parser.token "}"
            , Parser.chompWhile (\character -> character /= ' ' && character /= '\n') |> Parser.getChompedString
            ]


fieldParser : Parser (List Content)
fieldParser =
    Parser.loop [] statementsHelp


statementsHelp : List Content -> Parser (Parser.Step (List Content) (List Content))
statementsHelp revStmts =
    Parser.oneOf
        [ Parser.end
            |> Parser.map (\_ -> Parser.Done (List.reverse revStmts))
        , tokenParser |> Parser.map (\raw -> Parser.Loop (InterpolatedText raw :: revStmts))
        , Parser.chompUntilEndOr "$" |> Parser.getChompedString |> Parser.map (\raw -> Parser.Loop (RawText raw :: revStmts))
        ]


type Content
    = RawText String
    | InterpolatedText Variable


type Variable
    = Variable String


interpolationField : String -> InterpolationField
interpolationField =
    InterpolationField


type InterpolationField
    = InterpolationField String


toElmString : InterpolatedField -> String
toElmString (InterpolatedField raw) =
    case Parser.run fieldParser raw of
        Ok contents ->
            contents
                |> List.map
                    (\value ->
                        case value of
                            RawText rawText ->
                                escapedAndQuoted rawText

                            InterpolatedText (Variable variableName) ->
                                variableName |> String.toLower |> String.Extra.camelize
                    )
                |> String.join " ++ "

        -- TODO only add parens if more than 1? Or leave that up to the calling code?
        Err error ->
            "TODO"


referencedVariables : List Content -> List Variable
referencedVariables contents =
    contents
        |> List.filterMap
            (\text ->
                case text of
                    RawText _ ->
                        Nothing

                    InterpolatedText variable ->
                        Just variable
            )


escapedAndQuoted : String -> String
escapedAndQuoted string =
    "\"" ++ (string |> String.replace "\"" "\\\"") ++ "\""
