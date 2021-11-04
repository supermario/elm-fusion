module DataSourceGenerator exposing (..)

import Elm
import Elm.Gen.DataSource.Http
import Elm.Gen.Pages.Secrets
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

        requestRecord : String
        requestRecord =
            Elm.record
                [ Elm.field "url" (Elm.string request.url)
                , Elm.field "method" (request.method |> Request.methodToString |> Elm.string)
                , Elm.field "headers"
                    (request.headers
                        |> List.map
                            (\( key, value ) ->
                                Elm.tuple
                                    (InterpolatedField.toElmExpression key)
                                    (InterpolatedField.toElmExpression value)
                            )
                        |> Elm.list
                    )
                , Elm.field "body" (bodyGenerator request)
                ]
                |> Elm.toString
    in
    if List.isEmpty referencedVariables then
        """
data =
    DataSource.Http.request
        (Secrets.succeed
"""
            ++ indent (indent (indent requestRecord))
            ++ """
        )
"""

    else
        """
data =
    DataSource.Http.request
        (Secrets.succeed
"""
            ++ """            (\\authToken ->
"""
            ++ indent (indent (indent (indent requestRecord)))
            ++ "\n            )\n"
            ++ (List.map
                    (\variableName -> "            |> Secrets.with " ++ escapedAndQuoted variableName)
                    referencedVariables
                    |> String.join "\n"
               )
            ++ """
        )
"""


bodyGenerator : Request -> Elm.Expression
bodyGenerator request =
    case request.body of
        Request.Empty ->
            Elm.Gen.DataSource.Http.emptyBody

        Request.StringBody contentType body ->
            Elm.Gen.DataSource.Http.stringBody (Elm.string contentType) (Elm.string body)


escapedAndQuoted : String -> String
escapedAndQuoted string =
    string
        |> Elm.string
        |> Elm.toString


indent : String -> String
indent string =
    string
        |> String.lines
        |> List.map (\line -> "    " ++ line)
        |> String.join "\n"
