module DataSourceGenerator exposing (..)

import Elm
import Elm.Gen.DataSource.Http
import Elm.Gen.Pages.Secrets
import InterpolatedField
import List.NonEmpty
import Request exposing (Request)


generate : Request -> String
generate request =
    let
        referencedVariables : Maybe (List.NonEmpty.NonEmpty String)
        referencedVariables =
            request.headers
                |> List.concatMap
                    (\( key, value ) ->
                        InterpolatedField.referencedVariables key ++ InterpolatedField.referencedVariables value
                    )
                |> List.map InterpolatedField.variableName
                |> List.NonEmpty.fromList

        requestRecordExpression : Elm.Expression
        requestRecordExpression =
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
    in
    case referencedVariables of
        Nothing ->
            Elm.Gen.DataSource.Http.request
                (requestRecordExpression |> Elm.Gen.Pages.Secrets.succeed)
                (Elm.value "decoder")
                |> Elm.declaration "data"
                |> Elm.declarationToString

        Just variables ->
            """
data =
    DataSource.Http.request
        (Pages.Secrets.succeed
"""
                ++ """            (\\authToken ->
"""
                ++ indent (indent (indent (indent (requestRecordExpression |> Elm.toString))))
                ++ "\n            )\n"
                ++ (List.NonEmpty.map
                        (\variableName -> "            |> Secrets.with " ++ escapedAndQuoted variableName)
                        variables
                        |> List.NonEmpty.toList
                        |> String.join "\n"
                   )
                ++ """
        )
        decoder
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
