module CurlGenerator exposing (generate)

import InterpolatedField
import List.NonEmpty
import Request exposing (Request)


generate : Request -> String
generate request =
    [ [ "curl"
      , quoted (InterpolatedField.toString request.url)
      , "-X " ++ Request.methodToString request.method
      ]
    , List.map (\header -> "-H " ++ quoted header)
        (request.headers
            |> List.map
                (\( key, value ) ->
                    InterpolatedField.toString key
                        ++ ": "
                        ++ InterpolatedField.toString value
                )
        )
    , case request.auth of
        Just (Request.BasicAuth basicAuth) ->
            [ "-u "
                ++ quoted
                    (InterpolatedField.toString basicAuth.username
                        ++ ":"
                        ++ InterpolatedField.toString basicAuth.password
                    )
            ]

        Nothing ->
            []
    , case request.body of
        Request.StringBody contentType body ->
            [ "-H"
            , quoted ("Content-Type: " ++ contentType)
            , "-d"
            , quoted body
            ]

        Request.Empty ->
            []
    ]
        |> List.filterMap List.NonEmpty.fromList
        |> List.map List.NonEmpty.toList
        |> List.map (String.join " ")
        |> String.join " "


quoted : String -> String
quoted string =
    "\""
        ++ (string |> String.replace "\"" "\\\"")
        ++ "\""
