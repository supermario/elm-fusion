module Stubs.Response exposing (..)

import Fusion.Types exposing (HttpError)
import RemoteData exposing (RemoteData(..))
import String.Extra as String


basic1LevelJson : String
basic1LevelJson =
    """
    {
      "first": "Jane",
      "last": "Doe",
      "age": 34
    }
    """
        |> String.unindent
        |> String.trim


basic2LevelJson : String
basic2LevelJson =
    """
    {
      "first": "Jane",
      "last": "Doe",
      "favorite": "Chocolate",
      "address" : {
          "line1": "123 Test St",
          "line2": null,
          "state": "NSW",
          "country": "AU"
      }
    }
    """
        |> String.unindent
        |> String.trim


basic2LevelJsonResponse : RemoteData HttpError String
basic2LevelJsonResponse =
    Success basic2LevelJson
