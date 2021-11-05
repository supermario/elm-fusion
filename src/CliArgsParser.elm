module CliArgsParser exposing (parser)

import Parser exposing (..)


parser : Parser (List String)
parser =
    loop [] argsHelp


argsHelp : List String -> Parser (Step (List String) (List String))
argsHelp revChunks =
    oneOf
        [ end
            |> map (\_ -> Done (List.reverse revChunks))
        , token "\\\n"
            |> map (\_ -> Loop revChunks)
        , oneOrMoreSpaces |> Parser.map (\_ -> Loop revChunks)
        , string |> Parser.map (\newArg -> Loop (newArg :: revChunks))
        , singleQuoteString |> Parser.map (\newArg -> Loop (newArg :: revChunks))
        , chompIf isUninteresting
            |. chompWhile isUninteresting
            |> getChompedString
            |> map (\chunk -> Loop (chunk :: revChunks))
        ]


oneOrMoreSpaces : Parser ()
oneOrMoreSpaces =
    chompIf isSpace
        |. chompWhile isSpace


isSpace : Char -> Bool
isSpace c =
    c == ' ' || c == '\n' || c == '\u{000D}'


string : Parser String
string =
    succeed identity
        |. token "\""
        |= loop [] stringHelp


stringHelp : List String -> Parser (Step (List String) String)
stringHelp revChunks =
    oneOf
        [ succeed (\chunk -> Loop (chunk :: revChunks))
            |. token "\\"
            |= oneOf
                [ map (\_ -> "\n") (token "n")
                , map (\_ -> "\t") (token "t")
                , map (\_ -> "\u{000D}") (token "r")
                ]
        , token "\""
            |> map (\_ -> Done (String.join "" (List.reverse revChunks)))
        , (chompIf isUninterestingString
            |. chompWhile isUninterestingString
          )
            |> getChompedString
            |> map (\chunk -> Loop (chunk :: revChunks))
        ]


singleQuoteString : Parser String
singleQuoteString =
    succeed identity
        |. token "'"
        |= loop [] singleQuoteStringHelp


singleQuoteStringHelp : List String -> Parser (Step (List String) String)
singleQuoteStringHelp revChunks =
    oneOf
        [ succeed (\chunk -> Loop (chunk :: revChunks))
            |. token "\\"
            |= oneOf
                [ map (\_ -> "\n") (token "n")
                , map (\_ -> "\t") (token "t")
                , map (\_ -> "\u{000D}") (token "r")
                ]
        , token "'"
            |> map (\_ -> Done (String.join "" (List.reverse revChunks)))
        , (chompIf isUninterestingSingle
            |. chompWhile isUninterestingSingle
          )
            |> getChompedString
            |> map (\chunk -> Loop (chunk :: revChunks))
        ]


isUninterestingSingle : Char -> Bool
isUninterestingSingle char =
    char /= '\\' && char /= '\''


isUninteresting : Char -> Bool
isUninteresting char =
    char /= '\\' && char /= '"' && char /= '\'' && not (isSpace char)


isUninterestingString : Char -> Bool
isUninterestingString char =
    char /= '\\' && char /= '"'
