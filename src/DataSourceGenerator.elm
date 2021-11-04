module DataSourceGenerator exposing (..)

import Elm
import Elm.Annotation
import Elm.Gen.DataSource.Http
import Elm.Gen.Pages.Secrets
import Elm.Pattern
import InterpolatedField
import List.NonEmpty
import Request exposing (Request)


generate : Request -> Elm.Declaration
generate request =
    let
        requestRecordExpression : Elm.Expression
        requestRecordExpression =
            Elm.record
                [ Elm.field "url" (request.url |> InterpolatedField.toElmExpression)
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
    (case request |> Request.referencedVariables |> List.NonEmpty.fromList of
        Nothing ->
            Elm.Gen.DataSource.Http.request
                (requestRecordExpression |> Elm.Gen.Pages.Secrets.succeed)
                (Elm.value "decoder")

        Just variables ->
            let
                lambdaVars : List ( Elm.Pattern.Pattern, Elm.Annotation.Annotation )
                lambdaVars =
                    variables
                        |> List.NonEmpty.map (\variable -> ( InterpolatedField.toElmVar variable, Elm.Annotation.string ))
                        |> List.NonEmpty.toList

                requestLambda : Elm.Expression
                requestLambda =
                    Elm.lambdaWith
                        lambdaVars
                        requestRecordExpression
                        |> Elm.Gen.Pages.Secrets.succeed

                secretsPipeline : Elm.Expression
                secretsPipeline =
                    variables
                        |> List.NonEmpty.map (\variable -> Elm.apply (Elm.value "Secrets.with") [ Elm.string (InterpolatedField.rawVariableName variable) ])
                        |> List.NonEmpty.cons requestLambda
                        |> List.NonEmpty.foldr1 Elm.pipe
            in
            Elm.Gen.DataSource.Http.request
                secretsPipeline
                (Elm.value "decoder")
    )
        |> Elm.declaration "data"


bodyGenerator : Request -> Elm.Expression
bodyGenerator request =
    case request.body of
        Request.Empty ->
            Elm.Gen.DataSource.Http.emptyBody

        Request.StringBody contentType body ->
            Elm.Gen.DataSource.Http.stringBody (Elm.string contentType) (Elm.string body)


indent : String -> String
indent string =
    string
        |> String.lines
        |> List.map (\line -> "    " ++ line)
        |> String.join "\n"
