module DataSourceGeneratorTest exposing (..)

import DataSourceGenerator
import Expect
import Request
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "DataSourceGenerator"
        [ test "simple GET" <|
            \() ->
                { url = "https://example.com"
                , method = Request.GET
                , body = Request.Empty
                , headers = []
                , timeout = Nothing
                }
                    |> DataSourceGenerator.generate
                    |> Expect.equal
                        """
data =
    DataSource.Http.request
        (Secrets.succeed
            { url = "https://example.com"
            , method = "GET"
            , headers =
                [
                ]
            , body = DataSource.Http.emptyBody
            }
        )
"""
        ]
