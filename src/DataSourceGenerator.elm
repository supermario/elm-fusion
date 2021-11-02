module DataSourceGenerator exposing (..)

import Request exposing (Request)


generate : Request -> String
generate request =
    """
data =
    DataSource.Http.request
        (Secrets.succeed
            { url = \""""
        ++ request.url
        ++ """"
            , method = \""""
        ++ Request.methodToString request.method
        ++ """"
            , headers =
                [ """
        ++ (request.headers
                |> List.map (\( key, value ) -> "( \"" ++ key ++ "\", \"" ++ value ++ "\" )")
                |> String.join "\n                , "
           )
        ++ """
                ]
            , body = """
        ++ bodyGenerator request
        ++ """
            }
        )
"""


bodyGenerator : Request -> String
bodyGenerator request =
    case request.body of
        Request.Empty ->
            """DataSource.Http.emptyBody"""

        Request.StringBody contentType body ->
            "DataSource.Http.stringBody \""
                ++ contentType
                ++ "\" "
                ++ escapedAndQuoted body


escapedAndQuoted : String -> String
escapedAndQuoted string =
    "\"" ++ (string |> String.replace "\"" "\\\"") ++ "\""