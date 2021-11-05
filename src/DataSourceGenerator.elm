module DataSourceGenerator exposing (..)

import Dict exposing (Dict)
import Elm
import Elm.Annotation
import Elm.Gen.DataSource.Http
import Elm.Gen.Pages.Secrets
import Elm.Pattern
import InterpolatedField
import List.NonEmpty
import Request exposing (Request)
import VariableDefinition exposing (VariableDefinition)


generate : Dict String VariableDefinition -> Request -> Elm.Declaration
generate variableDefinitions request =
    let
        authHeaders : List Elm.Expression
        authHeaders =
            case request.auth of
                Just (Request.BasicAuth basicAuth) ->
                    [ Elm.tuple
                        (Elm.string "Authorization")
                        (Elm.apply (Elm.value "Base64.encode")
                            [ Elm.append
                                (Elm.append
                                    (InterpolatedField.toElmExpression basicAuth.username)
                                    (Elm.string ":")
                                )
                                (InterpolatedField.toElmExpression basicAuth.password)
                            ]
                        )
                    ]

                _ ->
                    []

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
                        |> List.append authHeaders
                        |> Elm.list
                    )
                , Elm.field "body" (bodyGenerator request)
                ]

        variablesWithVisibility : List ( InterpolatedField.Variable, VariableDefinition.Visibility )
        variablesWithVisibility =
            request
                |> Request.referencedVariables
                |> List.map
                    (\variable ->
                        ( variable
                        , Dict.get (InterpolatedField.rawVariableName variable) variableDefinitions
                            |> Maybe.withDefault VariableDefinition.default
                            |> VariableDefinition.visibility
                        )
                    )

        secrets : List InterpolatedField.Variable
        secrets =
            variablesWithVisibility
                |> List.filterMap
                    (\( variable, visibility ) ->
                        if visibility == VariableDefinition.Secret then
                            Just variable

                        else
                            Nothing
                    )

        params : List InterpolatedField.Variable
        params =
            variablesWithVisibility
                |> List.filterMap
                    (\( variable, visibility ) ->
                        if visibility == VariableDefinition.Parameter then
                            Just variable

                        else
                            Nothing
                    )
    in
    (case secrets |> List.NonEmpty.fromList of
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
        |> Elm.functionWith "data"
            (params
                |> List.map
                    (\param ->
                        ( Elm.Annotation.string
                        , InterpolatedField.toElmVar param
                        )
                    )
            )


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
