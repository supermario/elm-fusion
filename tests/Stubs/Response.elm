module Stubs.Response exposing (..)

import Fusion.Types exposing (HttpError)
import RemoteData exposing (RemoteData(..))


basicJson : RemoteData HttpError String
basicJson =
    """
    {
      "first": "Jane",
      "last": "Doe",
      "favorite": "Chocolate",
      "address" : {
          "line1": "123 Test St",
          "line2": "Testburbia",
          "state": "NSW",
          "country": "AU"
      }
    }
    """
        |> String.trim
        |> Success
