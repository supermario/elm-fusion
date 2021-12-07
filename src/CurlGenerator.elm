module CurlGenerator exposing (generate)

import Fusion.Types
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
        Fusion.Types.StringBody contentType body ->
            [ "-H"
            , quoted ("Content-Type: " ++ contentType)
            , "-d"
            , quoted body
            ]

        Fusion.Types.Empty ->
            []

        Fusion.Types.JsonBody jsonBody ->
            [ "-H"
            , quoted ("Content-Type: " ++ "application/json")
            , "-d"
            , quoted jsonBody
            ]
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
