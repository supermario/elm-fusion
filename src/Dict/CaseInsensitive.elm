module Dict.CaseInsensitive exposing
    ( Dict(..)
    , empty
    , filter
    , fromList
    , get
    , insert
    , toDict
    , toList
    )

import Dict


type Dict a
    = Dict (Dict.Dict String ( String, a ))


insert : String -> value -> Dict value -> Dict value
insert key value (Dict dict) =
    dict
        |> Dict.insert (String.toLower key) ( key, value )
        |> Dict


empty : Dict a
empty =
    Dict Dict.empty


toDict : Dict value -> Dict.Dict String value
toDict (Dict dict) =
    dict
        |> Dict.values
        |> Dict.fromList


toList : Dict value -> List ( String, value )
toList (Dict dict) =
    dict
        |> Dict.values


fromList : List ( String, value ) -> Dict value
fromList list =
    list
        |> List.map
            (\( key, value ) ->
                ( String.toLower key
                , ( key, value )
                )
            )
        |> Dict.fromList
        |> Dict


get : String -> Dict value -> Maybe value
get key (Dict dict) =
    dict
        |> Dict.get (String.toLower key)
        |> Maybe.map Tuple.second


filter : (String -> value -> Bool) -> Dict value -> Dict value
filter filterFn (Dict dict) =
    dict
        |> Dict.filter
            (\lowercaseKey ( _, value ) ->
                filterFn lowercaseKey value
            )
        |> Dict
