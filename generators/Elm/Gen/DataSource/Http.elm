module Elm.Gen.DataSource.Http exposing (emptyBody, expectString, expectUnoptimizedJson, get, id_, jsonBody, make_, moduleName_, request, stringBody, types_, unoptimizedRequest)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "DataSource", "Http" ]


types_ :
    { expect : Type.Annotation -> Type.Annotation
    , body : Type.Annotation
    , requestDetails : Type.Annotation
    }
types_ =
    { expect = \arg0 -> Type.namedWith moduleName_ "Expect" [ arg0 ]
    , body = Type.named moduleName_ "Body"
    , requestDetails = Type.named moduleName_ "RequestDetails"
    }


make_ : {}
make_ =
    {}


{-| A simplified helper around [`DataSource.Http.request`](#request), which builds up a DataSource.Http GET request.

    import DataSource
    import DataSource.Http
    import Json.Decode as Decode exposing (Decoder)

    getRequest : DataSource Int
    getRequest =
        DataSource.Http.get
            (Secrets.succeed "https://api.github.com/repos/dillonkearns/elm-pages")
            (Decode.field "stargazers_count" Decode.int)

-}
get : Elm.Expression -> Elm.Expression -> Elm.Expression
get arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "get"
            (Type.function
                [ Type.namedWith [ "Pages", "Secrets" ] "Value" [ Type.string ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
        )
        [ arg1, arg2 ]


{-| Build a `DataSource.Http` request (analagous to [Http.request](https://package.elm-lang.org/packages/elm/http/latest/Http#request)).
This function takes in all the details to build a `DataSource.Http` request, but you can build your own simplified helper functions
with this as a low-level detail, or you can use functions like [DataSource.Http.get](#get).
-}
request : Elm.Expression -> Elm.Expression -> Elm.Expression
request arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "request"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.namedWith
                        [ "DataSource", "Http" ]
                        "RequestDetails"
                        []
                    ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
        )
        [ arg1, arg2 ]


{-| Build an empty body for a DataSource.Http request. See [elm/http's `Http.emptyBody`](https://package.elm-lang.org/packages/elm/http/latest/Http#emptyBody).
-}
emptyBody : Elm.Expression
emptyBody =
    Elm.valueWith
        moduleName_
        "emptyBody"
        (Type.namedWith [ "DataSource", "Http" ] "Body" [])


{-| Builds a string body for a DataSource.Http request. See [elm/http's `Http.stringBody`](https://package.elm-lang.org/packages/elm/http/latest/Http#stringBody).

Note from the `elm/http` docs:

> The first argument is a [MIME type](https://en.wikipedia.org/wiki/Media_type) of the body. Some servers are strict about this!

-}
stringBody : Elm.Expression -> Elm.Expression -> Elm.Expression
stringBody arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "stringBody"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "DataSource", "Http" ] "Body" [])
            )
        )
        [ arg1, arg2 ]


{-| Builds a JSON body for a DataSource.Http request. See [elm/http's `Http.jsonBody`](https://package.elm-lang.org/packages/elm/http/latest/Http#jsonBody).
-}
jsonBody : Elm.Expression -> Elm.Expression
jsonBody arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "jsonBody"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [] ]
                (Type.namedWith [ "DataSource", "Http" ] "Body" [])
            )
        )
        [ arg1 ]


{-| This is an alternative to the other request functions in this module that doesn't perform any optimizations on the
asset. Be sure to use the optimized versions, like `DataSource.Http.request`, if you can. Using those can significantly reduce
your asset sizes by removing all unused fields from your JSON.

You may want to use this function instead if you need XML data or plaintext. Or maybe you're hitting a GraphQL API,
so you don't need any additional optimization as the payload is already reduced down to exactly what you requested.

-}
unoptimizedRequest : Elm.Expression -> Elm.Expression -> Elm.Expression
unoptimizedRequest arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "unoptimizedRequest"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.namedWith
                        [ "DataSource", "Http" ]
                        "RequestDetails"
                        []
                    ]
                , Type.namedWith
                    [ "DataSource", "Http" ]
                    "Expect"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
        )
        [ arg1, arg2 ]


{-| Request a raw String. You can validate the String if you need to check the formatting, or try to parse it
in something besides JSON. Be sure to use the `DataSource.Http.request` function if you want an optimized request that
strips out unused JSON to optimize your asset size.

If the function you pass to `expectString` yields an `Err`, then you will get a build error that will
fail your `elm-pages` build and print out the String from the `Err`.

    request =
        DataSource.Http.unoptimizedRequest
            (Secrets.succeed
                { url = "https://example.com/file.txt"
                , method = "GET"
                , headers = []
                , body = DataSource.Http.emptyBody
                }
            )
            (DataSource.Http.expectString
                (\string ->
                    if String.toUpper string == string then
                        Ok string

                    else
                        Err "String was not uppercased"
                )
            )

-}
expectString : (Elm.Expression -> Elm.Expression) -> Elm.Expression
expectString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectString"
            (Type.function
                [ Type.function
                    [ Type.string ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.string, Type.var "value" ]
                    )
                ]
                (Type.namedWith
                    [ "DataSource", "Http" ]
                    "Expect"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 Elm.pass ]


{-| Handle the incoming response as JSON and don't optimize the asset and strip out unused values.
Be sure to use the `DataSource.Http.request` function if you want an optimized request that
strips out unused JSON to optimize your asset size. This function makes sense to use for things like a GraphQL request
where the JSON payload is already trimmed down to the data you explicitly requested.

If the function you pass to `expectString` yields an `Err`, then you will get a build error that will
fail your `elm-pages` build and print out the String from the `Err`.

-}
expectUnoptimizedJson : Elm.Expression -> Elm.Expression
expectUnoptimizedJson arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectUnoptimizedJson"
            (Type.function
                [ Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource", "Http" ]
                    "Expect"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { get : Elm.Expression
    , request : Elm.Expression
    , emptyBody : Elm.Expression
    , stringBody : Elm.Expression
    , jsonBody : Elm.Expression
    , unoptimizedRequest : Elm.Expression
    , expectString : Elm.Expression
    , expectUnoptimizedJson : Elm.Expression
    }
id_ =
    { get =
        Elm.valueWith
            moduleName_
            "get"
            (Type.function
                [ Type.namedWith [ "Pages", "Secrets" ] "Value" [ Type.string ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
    , request =
        Elm.valueWith
            moduleName_
            "request"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.namedWith
                        [ "DataSource", "Http" ]
                        "RequestDetails"
                        []
                    ]
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
    , emptyBody =
        Elm.valueWith
            moduleName_
            "emptyBody"
            (Type.namedWith [ "DataSource", "Http" ] "Body" [])
    , stringBody =
        Elm.valueWith
            moduleName_
            "stringBody"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "DataSource", "Http" ] "Body" [])
            )
    , jsonBody =
        Elm.valueWith
            moduleName_
            "jsonBody"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [] ]
                (Type.namedWith [ "DataSource", "Http" ] "Body" [])
            )
    , unoptimizedRequest =
        Elm.valueWith
            moduleName_
            "unoptimizedRequest"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Secrets" ]
                    "Value"
                    [ Type.namedWith
                        [ "DataSource", "Http" ]
                        "RequestDetails"
                        []
                    ]
                , Type.namedWith
                    [ "DataSource", "Http" ]
                    "Expect"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
    , expectString =
        Elm.valueWith
            moduleName_
            "expectString"
            (Type.function
                [ Type.function
                    [ Type.string ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.string, Type.var "value" ]
                    )
                ]
                (Type.namedWith
                    [ "DataSource", "Http" ]
                    "Expect"
                    [ Type.var "value" ]
                )
            )
    , expectUnoptimizedJson =
        Elm.valueWith
            moduleName_
            "expectUnoptimizedJson"
            (Type.function
                [ Type.namedWith
                    [ "Json", "Decode" ]
                    "Decoder"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource", "Http" ]
                    "Expect"
                    [ Type.var "value" ]
                )
            )
    }


