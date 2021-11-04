module Elm.Gen.DataSource exposing (andMap, andThen, combine, distill, distillCodec, distillSerializeCodec, fail, fromResult, id_, make_, map, map2, map3, map4, map5, map6, map7, map8, map9, moduleName_, resolve, succeed, types_, validate)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "DataSource" ]


types_ : { dataSource : Type.Annotation -> Type.Annotation }
types_ =
    { dataSource = \arg0 -> Type.namedWith moduleName_ "DataSource" [ arg0 ] }


make_ : {}
make_ =
    {}


{-| Transform a request into an arbitrary value. The same underlying HTTP requests will be performed during the build
step, but mapping allows you to change the resulting values by applying functions to the results.

A common use for this is to map your data into your elm-pages view:

    import DataSource
    import Json.Decode as Decode exposing (Decoder)

    view =
        DataSource.Http.get
            (Secrets.succeed "https://api.github.com/repos/dillonkearns/elm-pages")
            (Decode.field "stargazers_count" Decode.int)
            |> DataSource.map
                (\stars ->
                    { view =
                        \model viewForPage ->
                            { title = "Current stars: " ++ String.fromInt stars
                            , body = Html.text <| "⭐️ " ++ String.fromInt stars
                            , head = []
                            }
                    }
                )

-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| This is useful for prototyping with some hardcoded data, or for having a view that doesn't have any StaticHttp data.

    import DataSource

    view :
        List ( PagePath, Metadata )
        ->
            { path : PagePath
            , frontmatter : Metadata
            }
        ->
            StaticHttp.Request
                { view : Model -> View -> { title : String, body : Html Msg }
                , head : List (Head.Tag Pages.PathKey)
                }
    view siteMetadata page =
        StaticHttp.succeed
            { view =
                \model viewForPage ->
                    mainView model viewForPage
            , head = head page.frontmatter
            }

-}
succeed : Elm.Expression -> Elm.Expression
succeed arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
        )
        [ arg1 ]


{-| Stop the StaticHttp chain with the given error message. If you reach a `fail` in your request,
you will get a build error. Or in the dev server, you will see the error message in an overlay in your browser (and in
the terminal).
-}
fail : Elm.Expression -> Elm.Expression
fail arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
        )
        [ arg1 ]


{-| Turn an Err into a DataSource failure.
-}
fromResult : Elm.Expression -> Elm.Expression
fromResult arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromResult"
            (Type.function
                [ Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.string, Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 ]


{-| Build off of the response from a previous `StaticHttp` request to build a follow-up request. You can use the data
from the previous response to build up the URL, headers, etc. that you send to the subsequent request.

    import DataSource
    import Json.Decode as Decode exposing (Decoder)

    licenseData : StaticHttp.Request String
    licenseData =
        StaticHttp.get
            (Secrets.succeed "https://api.github.com/repos/dillonkearns/elm-pages")
            (Decode.at [ "license", "url" ] Decode.string)
            |> StaticHttp.andThen
                (\licenseUrl ->
                    StaticHttp.get (Secrets.succeed licenseUrl) (Decode.field "description" Decode.string)
                )

-}
andThen : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
andThen arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.var "b" ]
                    )
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Helper to remove an inner layer of Request wrapping.
-}
resolve : Elm.Expression -> Elm.Expression
resolve arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "resolve"
            (Type.function
                [ Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list
                        (Type.namedWith
                            [ "DataSource" ]
                            "DataSource"
                            [ Type.var "value" ]
                        )
                    ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list (Type.var "value") ]
                )
            )
        )
        [ arg1 ]


{-| Turn a list of `StaticHttp.Request`s into a single one.

    import DataSource
    import Json.Decode as Decode exposing (Decoder)

    type alias Pokemon =
        { name : String
        , sprite : String
        }

    pokemonDetailRequest : StaticHttp.Request (List Pokemon)
    pokemonDetailRequest =
        StaticHttp.get
            (Secrets.succeed "https://pokeapi.co/api/v2/pokemon/?limit=3")
            (Decode.field "results"
                (Decode.list
                    (Decode.map2 Tuple.pair
                        (Decode.field "name" Decode.string)
                        (Decode.field "url" Decode.string)
                        |> Decode.map
                            (\( name, url ) ->
                                StaticHttp.get (Secrets.succeed url)
                                    (Decode.at
                                        [ "sprites", "front_default" ]
                                        Decode.string
                                        |> Decode.map (Pokemon name)
                                    )
                            )
                    )
                )
            )
            |> StaticHttp.andThen StaticHttp.combine

-}
combine : List Elm.Expression -> Elm.Expression
combine arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "combine"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.var "value" ]
                    )
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list (Type.var "value") ]
                )
            )
        )
        [ Elm.list arg1 ]


{-| A helper for combining `DataSource`s in pipelines.
-}
andMap : Elm.Expression -> Elm.Expression -> Elm.Expression
andMap arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andMap"
            (Type.function
                [ Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.function [ Type.var "a" ] (Type.var "b") ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
        )
        [ arg1, arg2 ]


{-| Like map, but it takes in two `Request`s.

    view siteMetadata page =
        StaticHttp.map2
            (\elmPagesStars elmMarkdownStars ->
                { view =
                    \model viewForPage ->
                        { title = "Repo Stargazers"
                        , body = starsView elmPagesStars elmMarkdownStars
                        }
                , head = head elmPagesStars elmMarkdownStars
                }
            )
            (get
                (Secrets.succeed "https://api.github.com/repos/dillonkearns/elm-pages")
                (Decode.field "stargazers_count" Decode.int)
            )
            (get
                (Secrets.succeed "https://api.github.com/repos/dillonkearns/elm-markdown")
                (Decode.field "stargazers_count" Decode.int)
            )

-}
map2 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map2 arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "c")
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "c" ])
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-| -}
map3 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map3 arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "value1", Type.var "value2", Type.var "value3" ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4 ]


{-| -}
map4 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map4 arg1 arg2 arg3 arg4 arg5 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4, arg5 ]


{-| -}
map5 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map5 arg1 arg2 arg3 arg4 arg5 arg6 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        ]


{-| -}
map6 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map6 arg1 arg2 arg3 arg4 arg5 arg6 arg7 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map6"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        ]


{-| -}
map7 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map7 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map7"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    , Type.var "value7"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value7" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        , arg8
        ]


{-| -}
map8 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map8 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map8"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    , Type.var "value7"
                    , Type.var "value8"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value7" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value8" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
        )
        [ arg1
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        , arg8
        , arg9
        ]


{-| -}
map9 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map9 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 arg10 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map9"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    , Type.var "value7"
                    , Type.var "value8"
                    , Type.var "value9"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value7" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value8" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value9" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
        )
        [ arg1
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
            Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        , arg7
        , arg8
        , arg9
        , arg10
        ]


{-| This is the low-level `distill` function. In most cases, you'll want to use `distill` with a `Codec` from either
[`miniBill/elm-codec`](https://package.elm-lang.org/packages/miniBill/elm-codec/latest/) or
[`MartinSStewart/elm-serialize`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/)
-}
distill :
    Elm.Expression
    -> (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
distill arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "distill"
            (Type.function
                [ Type.string
                , Type.function
                    [ Type.var "raw" ]
                    (Type.namedWith [ "Json", "Encode" ] "Value" [])
                , Type.function
                    [ Type.namedWith [ "Json", "Decode" ] "Value" [] ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.string, Type.var "distilled" ]
                    )
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "raw" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "distilled" ]
                )
            )
        )
        [ arg1, arg2 Elm.pass, arg3 Elm.pass, arg4 ]


{-| -}
validate :
    (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
validate arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "validate"
            (Type.function
                [ Type.function
                    [ Type.var "unvalidated" ]
                    (Type.var "validated")
                , Type.function
                    [ Type.var "unvalidated" ]
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.namedWith
                            [ "Result" ]
                            "Result"
                            [ Type.string, Type.unit ]
                        ]
                    )
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "unvalidated" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "validated" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 Elm.pass, arg3 ]


{-| [`distill`](#distill) with a `Codec` from [`miniBill/elm-codec`](https://package.elm-lang.org/packages/miniBill/elm-codec/latest/).

    import Codec
    import DataSource
    import DataSource.Http
    import Secrets

    millionRandomSum : DataSource Int
    millionRandomSum =
        DataSource.Http.get
            (Secrets.succeed "https://example.com/api/one-million-random-numbers.json")
            (Decode.list Decode.int)
            |> DataSource.map List.sum
            -- all of this expensive computation and data will happen before it hits the client!
            -- the user's browser simply loads up a single Int and runs an Int decoder to get it
            |> DataSource.distillCodec "million-random-sum" Codec.int

If we didn't distill the data here, then all million Ints would have to be loaded in order to load the page.
The reason the data for these `DataSource`s needs to be loaded is that `elm-pages` hydrates into an Elm app. If it
output only HTML then we could build the HTML and throw away the data. But we need to ensure that the hydrated Elm app
has all the data that a page depends on, even if it the HTML for the page is also pre-rendered.

Using a `Codec` makes it safer to distill data because you know it is reversible.

-}
distillCodec :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
distillCodec arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "distillCodec"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Codec" ] "Codec" [ Type.var "value" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1, arg2, arg3 ]


{-| [`distill`](#distill) with a `Serialize.Codec` from [`MartinSStewart/elm-serialize`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest).

    import DataSource
    import DataSource.Http
    import Secrets
    import Serialize

    millionRandomSum : DataSource Int
    millionRandomSum =
        DataSource.Http.get
            (Secrets.succeed "https://example.com/api/one-million-random-numbers.json")
            (Decode.list Decode.int)
            |> DataSource.map List.sum
            -- all of this expensive computation and data will happen before it hits the client!
            -- the user's browser simply loads up a single Int and runs an Int decoder to get it
            |> DataSource.distillSerializeCodec "million-random-sum" Serialize.int

If we didn't distill the data here, then all million Ints would have to be loaded in order to load the page.
The reason the data for these `DataSource`s needs to be loaded is that `elm-pages` hydrates into an Elm app. If it
output only HTML then we could build the HTML and throw away the data. But we need to ensure that the hydrated Elm app
has all the data that a page depends on, even if it the HTML for the page is also pre-rendered.

Using a `Codec` makes it safer to distill data because you know it is reversible.

-}
distillSerializeCodec :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
distillSerializeCodec arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "distillSerializeCodec"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "Serialize" ]
                    "Codec"
                    [ Type.var "error", Type.var "value" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1, arg2, arg3 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { map : Elm.Expression
    , succeed : Elm.Expression
    , fail : Elm.Expression
    , fromResult : Elm.Expression
    , andThen : Elm.Expression
    , resolve : Elm.Expression
    , combine : Elm.Expression
    , andMap : Elm.Expression
    , map2 : Elm.Expression
    , map3 : Elm.Expression
    , map4 : Elm.Expression
    , map5 : Elm.Expression
    , map6 : Elm.Expression
    , map7 : Elm.Expression
    , map8 : Elm.Expression
    , map9 : Elm.Expression
    , distill : Elm.Expression
    , validate : Elm.Expression
    , distillCodec : Elm.Expression
    , distillSerializeCodec : Elm.Expression
    }
id_ =
    { map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
    , fail =
        Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
    , fromResult =
        Elm.valueWith
            moduleName_
            "fromResult"
            (Type.function
                [ Type.namedWith
                    [ "Result" ]
                    "Result"
                    [ Type.string, Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                )
            )
    , andThen =
        Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.var "b" ]
                    )
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
    , resolve =
        Elm.valueWith
            moduleName_
            "resolve"
            (Type.function
                [ Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list
                        (Type.namedWith
                            [ "DataSource" ]
                            "DataSource"
                            [ Type.var "value" ]
                        )
                    ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list (Type.var "value") ]
                )
            )
    , combine =
        Elm.valueWith
            moduleName_
            "combine"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.var "value" ]
                    )
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list (Type.var "value") ]
                )
            )
    , andMap =
        Elm.valueWith
            moduleName_
            "andMap"
            (Type.function
                [ Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.function [ Type.var "a" ] (Type.var "b") ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function [ Type.var "a", Type.var "b" ] (Type.var "c")
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ]
                , Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "c" ])
            )
    , map3 =
        Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "value1", Type.var "value2", Type.var "value3" ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
    , map4 =
        Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
    , map5 =
        Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
    , map6 =
        Elm.valueWith
            moduleName_
            "map6"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
    , map7 =
        Elm.valueWith
            moduleName_
            "map7"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    , Type.var "value7"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value7" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
    , map8 =
        Elm.valueWith
            moduleName_
            "map8"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    , Type.var "value7"
                    , Type.var "value8"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value7" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value8" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
    , map9 =
        Elm.valueWith
            moduleName_
            "map9"
            (Type.function
                [ Type.function
                    [ Type.var "value1"
                    , Type.var "value2"
                    , Type.var "value3"
                    , Type.var "value4"
                    , Type.var "value5"
                    , Type.var "value6"
                    , Type.var "value7"
                    , Type.var "value8"
                    , Type.var "value9"
                    ]
                    (Type.var "valueCombined")
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value1" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value2" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value3" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value4" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value5" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value6" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value7" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value8" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value9" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "valueCombined" ]
                )
            )
    , distill =
        Elm.valueWith
            moduleName_
            "distill"
            (Type.function
                [ Type.string
                , Type.function
                    [ Type.var "raw" ]
                    (Type.namedWith [ "Json", "Encode" ] "Value" [])
                , Type.function
                    [ Type.namedWith [ "Json", "Decode" ] "Value" [] ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.string, Type.var "distilled" ]
                    )
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "raw" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "distilled" ]
                )
            )
    , validate =
        Elm.valueWith
            moduleName_
            "validate"
            (Type.function
                [ Type.function
                    [ Type.var "unvalidated" ]
                    (Type.var "validated")
                , Type.function
                    [ Type.var "unvalidated" ]
                    (Type.namedWith
                        [ "DataSource" ]
                        "DataSource"
                        [ Type.namedWith
                            [ "Result" ]
                            "Result"
                            [ Type.string, Type.unit ]
                        ]
                    )
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "unvalidated" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "validated" ]
                )
            )
    , distillCodec =
        Elm.valueWith
            moduleName_
            "distillCodec"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Codec" ] "Codec" [ Type.var "value" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                )
            )
    , distillSerializeCodec =
        Elm.valueWith
            moduleName_
            "distillSerializeCodec"
            (Type.function
                [ Type.string
                , Type.namedWith
                    [ "Serialize" ]
                    "Codec"
                    [ Type.var "error", Type.var "value" ]
                , Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "value" ]
                )
            )
    }


