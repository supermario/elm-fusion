module ElmHttpGenerator exposing (generate)

import Elm
import Elm.Annotation
import Elm.Gen.Http
import InterpolatedField
import Request exposing (Request)


generate : Request -> String
generate request =
    if List.isEmpty request.headers then
        """
request toMsg =
    Http.get
        { url = """ ++ escapedAndQuoted request.url ++ """
        , expect = Http.expectJson toMsg decoder
        }
"""

    else
        (\_ ->
            Elm.Gen.Http.request
                { url = Elm.string request.url
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
            |> Elm.fn "request" ( "toMsg", Elm.Annotation.unit )
            |> Elm.declarationToString


escapedAndQuoted : String -> String
escapedAndQuoted string =
    "\"" ++ (string |> String.replace "\"" "\\\"") ++ "\""
