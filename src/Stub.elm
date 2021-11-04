module Stub exposing (..)

import Fusion.Types exposing (HttpError)
import RemoteData exposing (RemoteData(..))


basicJson : RemoteData HttpError String
basicJson =
    """
    {
      "first": "Jane",
      "last": "Doe",
      "favorite": "Chocolate"
    }
    """
        |> String.trim
        |> Success
