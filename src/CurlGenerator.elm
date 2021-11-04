module CurlGenerator exposing (generate)

import InterpolatedField
import Request exposing (Request)


generate : Request -> String
generate request =
    let
        authHeaders : String
        authHeaders =
            case request.auth of
                Just (Request.BasicAuth basicAuth) ->
                    " -u "
                        ++ quoted
                            (InterpolatedField.toString basicAuth.username
                                ++ ":"
                                ++ InterpolatedField.toString basicAuth.password
                            )

                _ ->
                    ""
    in
    """curl """
        ++ quoted (InterpolatedField.toString request.url)
        ++ " "
        ++ (List.map (\header -> "-H " ++ quoted header)
                (request.headers
                    |> List.map
                        (\( key, value ) ->
                            InterpolatedField.toString key
                                ++ ": "
                                ++ InterpolatedField.toString value
                        )
                )
                |> String.join " "
           )
        ++ authHeaders


quoted : String -> String
quoted string =
    "\"" ++ string ++ "\""
