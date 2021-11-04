module ElmHttpGenerator exposing (generate)

import Elm
import Elm.Annotation
import Elm.Gen.Http
import Elm.Pattern
import InterpolatedField
import Request exposing (Request)


generate : Request -> Elm.Declaration
generate request =
    (if List.isEmpty request.headers then
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
