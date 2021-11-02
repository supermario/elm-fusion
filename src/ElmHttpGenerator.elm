module ElmHttpGenerator exposing (generate)

import Request exposing (Request)


generate : Request -> String
generate request =
    if List.isEmpty request.headers then
        """
request toMsg =
    Http.get
        { url = """ ++ escapedAndQuoted request.url ++ """
        , expect = Http.expectString toMsg
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
            ++ (request.headers |> List.map (\( key, value ) -> "Http.header " ++ escapedAndQuoted key ++ " " ++ escapedAndQuoted value) |> String.join "\n            , ")
            ++ """
            ]
        , url = """
            ++ escapedAndQuoted request.url
            ++ """
        , body = Http.emptyBody
        , expect = Http.expectString toMsg
        , timeout = Nothing
        , tracker = Nothing
        }
"""


escapedAndQuoted : String -> String
escapedAndQuoted string =
    "\"" ++ (string |> String.replace "\"" "\\\"") ++ "\""
