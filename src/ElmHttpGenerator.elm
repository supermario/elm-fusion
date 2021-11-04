module ElmHttpGenerator exposing (generate)

import Dict
import InterpolatedField
import Request exposing (Request)


generate : Request -> String
generate request =
    if List.isEmpty (request.headers |> Debug.log "headers") then
        """
request toMsg =
    Http.get
        { url = """ ++ escapedAndQuoted request.url ++ """
        , expect = Http.expectJson toMsg decoder
        }
"""

    else
        """
request toMsg =
    Http.request
        { method = """
            ++ escapedAndQuoted (Request.methodToString request.method)
            ++ """
        , headers =
            [ """
            ++ (request.headers
                    |> List.map
                        (\( key, value ) ->
                            "Http.header "
                                ++ escapedAndQuoted (InterpolatedField.interpolate Dict.empty key)
                                ++ " "
                                ++ escapedAndQuoted (InterpolatedField.interpolate Dict.empty value)
                        )
                    |> String.join "\n            , "
               )
            ++ """
            ]
        , url = """
            ++ escapedAndQuoted request.url
            ++ """
        , body = Http.emptyBody
        , expect = Http.expectJson toMsg decoder
        , timeout = Nothing
        , tracker = Nothing
        }
"""


escapedAndQuoted : String -> String
escapedAndQuoted string =
    "\"" ++ (string |> String.replace "\"" "\\\"") ++ "\""
