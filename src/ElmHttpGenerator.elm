module ElmHttpGenerator exposing (generate)

import Elm
import Elm.Annotation
import Elm.Gen.Http
import Elm.Pattern
import InterpolatedField
import Request exposing (Request)


generate : Request -> Elm.Declaration
generate request =
    let
        authHeaders : List Elm.Expression
        authHeaders =
            case request.auth of
                Just (Request.BasicAuth basicAuth) ->
                    [ Elm.Gen.Http.header
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
    in
    (if List.isEmpty request.headers && List.isEmpty authHeaders then
        Elm.Gen.Http.get
            { url = InterpolatedField.toElmExpression request.url
            , expect = Elm.Gen.Http.expectJson (\_ -> Elm.value "toMsg") (Elm.value "decoder")
            }

     else
        Elm.Gen.Http.request
            { url = InterpolatedField.toElmExpression request.url
            , headers =
                request.headers
                    |> List.map
                        (\( key, value ) ->
                            Elm.Gen.Http.header
                                (InterpolatedField.toElmExpression key)
                                (InterpolatedField.toElmExpression value)
                        )
                    |> List.append authHeaders
                    |> Elm.list
            , method = request.method |> Request.methodToString |> Elm.string
            , body = Elm.Gen.Http.emptyBody
            , timeout = Elm.value "Nothing"
            , expect = Elm.Gen.Http.expectJson (\_ -> Elm.value "toMsg") (Elm.value "decoder")
            , tracker = Elm.value "Nothing"
            }
    )
        |> Elm.functionWith "request"
            (toMsgParam
                :: List.map
                    (\variable ->
                        ( Elm.Annotation.string
                        , InterpolatedField.toElmVar variable
                        )
                    )
                    (Request.referencedVariables request)
            )


toMsgParam : ( Elm.Annotation.Annotation, Elm.Pattern.Pattern )
toMsgParam =
    ( Elm.Annotation.unit, Elm.Pattern.var "toMsg" )
