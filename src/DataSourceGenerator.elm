module DataSourceGenerator exposing (..)

import Dict
import InterpolatedField
import Request exposing (Request)


generate : Request -> String
generate request =
    let
        referencedVariables : List String
        referencedVariables =
            request.headers
                |> List.concatMap
                    (\( key, value ) ->
                        InterpolatedField.referencedVariables key ++ InterpolatedField.referencedVariables value
                    )
                |> List.map InterpolatedField.variableName

        innerPart =
            """            { url = \""""
                ++ request.url
                ++ """"
            , method = \""""
                ++ Request.methodToString request.method
                ++ """"
            , headers =
                [ """
                ++ (request.headers
                        |> List.map
                            (\( key, value ) ->
                                "( "
                                    ++ InterpolatedField.toElmString key
                                    ++ ", "
                                    ++ InterpolatedField.toElmString value
                                    ++ " )"
                            )
                        |> String.join "\n                , "
                   )
                ++ """
                ]
            , body = """
                ++ bodyGenerator request
                ++ """
            }"""
    in
    """
data =
    DataSource.Http.request
        (Secrets.succeed
"""
        ++ (if List.isEmpty referencedVariables then
                innerPart

            else
                """            (\\authToken ->
"""
                    ++ indent innerPart
                    ++ "\n            )\n"
                    ++ (List.map (\variableName -> "            |> Secrets.with " ++ escapedAndQuoted variableName) referencedVariables |> String.join "\n")
           )
        ++ """
        )
"""


bodyGenerator : Request -> String
bodyGenerator request =
    case request.body of
        Request.Empty ->
            """DataSource.Http.emptyBody"""

        Request.StringBody contentType body ->
            "DataSource.Http.stringBody "
                ++ escapedAndQuoted contentType
                ++ " "
                ++ escapedAndQuoted body


escapedAndQuoted : String -> String
escapedAndQuoted string =
    "\"" ++ (string |> String.replace "\"" "\\\"") ++ "\""


indent : String -> String
indent string =
    string
        |> String.lines
        |> List.map (\line -> "    " ++ line)
        |> String.join "\n"
