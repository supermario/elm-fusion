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
            , body = DataSource.Http.emptyBody
            }
        )
"""
