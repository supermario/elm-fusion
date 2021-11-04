module Elm.Gen.Http exposing (bytesBody, bytesPart, bytesResolver, cancel, emptyBody, expectBytes, expectBytesResponse, expectJson, expectString, expectStringResponse, expectWhatever, fileBody, filePart, fractionReceived, fractionSent, get, header, id_, jsonBody, make_, moduleName_, multipartBody, post, request, riskyRequest, riskyTask, stringBody, stringPart, stringResolver, task, track, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Http" ]


types_ :
    { resolver : Type.Annotation -> Type.Annotation -> Type.Annotation
    , metadata : Type.Annotation
    , response : Type.Annotation -> Type.Annotation
    , progress : Type.Annotation
    , error : Type.Annotation
    , expect : Type.Annotation -> Type.Annotation
    , part : Type.Annotation
    , body : Type.Annotation
    , header : Type.Annotation
    }
types_ =
    { resolver =
        \arg0 arg1 -> Type.namedWith moduleName_ "Resolver" [ arg0, arg1 ]
    , metadata = Type.named moduleName_ "Metadata"
    , response = \arg0 -> Type.namedWith moduleName_ "Response" [ arg0 ]
    , progress = Type.named moduleName_ "Progress"
    , error = Type.named moduleName_ "Error"
    , expect = \arg0 -> Type.namedWith moduleName_ "Expect" [ arg0 ]
    , part = Type.named moduleName_ "Part"
    , body = Type.named moduleName_ "Body"
    , header = Type.named moduleName_ "Header"
    }


make_ :
    { response :
        { badUrl_ : Elm.Expression -> Elm.Expression
        , timeout_ : Elm.Expression
        , networkError_ : Elm.Expression
        , badStatus_ : Elm.Expression -> Elm.Expression -> Elm.Expression
        , goodStatus_ : Elm.Expression -> Elm.Expression -> Elm.Expression
        }
    , progress :
        { sending : Elm.Expression -> Elm.Expression
        , receiving : Elm.Expression -> Elm.Expression
        }
    , error :
        { badUrl : Elm.Expression -> Elm.Expression
        , timeout : Elm.Expression
        , networkError : Elm.Expression
        , badStatus : Elm.Expression -> Elm.Expression
        , badBody : Elm.Expression -> Elm.Expression
        }
    }
make_ =
    { response =
        { badUrl_ =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadUrl_"
                        (Type.namedWith [] "Response" [ Type.var "body" ])
                    )
                    [ ar0 ]
        , timeout_ =
            Elm.valueWith
                moduleName_
                "Timeout_"
                (Type.namedWith [] "Response" [ Type.var "body" ])
        , networkError_ =
            Elm.valueWith
                moduleName_
                "NetworkError_"
                (Type.namedWith [] "Response" [ Type.var "body" ])
        , badStatus_ =
            \ar0 ar1 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadStatus_"
                        (Type.namedWith [] "Response" [ Type.var "body" ])
                    )
                    [ ar0, ar1 ]
        , goodStatus_ =
            \ar0 ar1 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "GoodStatus_"
                        (Type.namedWith [] "Response" [ Type.var "body" ])
                    )
                    [ ar0, ar1 ]
        }
    , progress =
        { sending =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "Sending"
                        (Type.namedWith [] "Progress" [])
                    )
                    [ ar0 ]
        , receiving =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "Receiving"
                        (Type.namedWith [] "Progress" [])
                    )
                    [ ar0 ]
        }
    , error =
        { badUrl =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadUrl"
                        (Type.namedWith [] "Error" [])
                    )
                    [ ar0 ]
        , timeout =
            Elm.valueWith moduleName_ "Timeout" (Type.namedWith [] "Error" [])
        , networkError =
            Elm.valueWith
                moduleName_
                "NetworkError"
                (Type.namedWith [] "Error" [])
        , badStatus =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadStatus"
                        (Type.namedWith [] "Error" [])
                    )
                    [ ar0 ]
        , badBody =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "BadBody"
                        (Type.namedWith [] "Error" [])
                    )
                    [ ar0 ]
        }
    }


{-| Create a `GET` request.

    import Http

    type Msg
      = GotText (Result Http.Error String)

    getPublicOpinion : Cmd Msg
    getPublicOpinion =
      Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }

You can use functions like [`expectString`](#expectString) and
[`expectJson`](#expectJson) to interpret the response in different ways. In
this example, we are expecting the response body to be a `String` containing
the full text of _Public Opinion_ by Walter Lippmann.

**Note:** Use [`elm/url`](/packages/elm/url/latest) to build reliable URLs.
-}
get : { url : Elm.Expression, expect : Elm.Expression } -> Elm.Expression
get arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "get"
            (Type.function
                [ Type.record
                    [ ( "url", Type.string )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ Elm.record
            [ Elm.field "url" arg1.url, Elm.field "expect" arg1.expect ]
        ]


{-| Create a `POST` request. So imagine we want to send a POST request for
some JSON data. It might look like this:

    import Http
    import Json.Decode exposing (list, string)

    type Msg
      = GotBooks (Result Http.Error (List String))

    postBooks : Cmd Msg
    postBooks =
      Http.post
        { url = "https://example.com/books"
        , body = Http.emptyBody
        , expect = Http.expectJson GotBooks (list string)
        }

Notice that we are using [`expectJson`](#expectJson) to interpret the response
as JSON. You can learn more about how JSON decoders work [here][] in the guide.

We did not put anything in the body of our request, but you can use functions
like [`stringBody`](#stringBody) and [`jsonBody`](#jsonBody) if you need to
send information to the server.

[here]: https://guide.elm-lang.org/interop/json.html
-}
post :
    { url : Elm.Expression, body : Elm.Expression, expect : Elm.Expression }
    -> Elm.Expression
post arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "post"
            (Type.function
                [ Type.record
                    [ ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ Elm.record
            [ Elm.field "url" arg1.url
            , Elm.field "body" arg1.body
            , Elm.field "expect" arg1.expect
            ]
        ]


{-| Create a custom request. For example, a PUT for files might look like this:

    import File
    import Http

    type Msg = Uploaded (Result Http.Error ())

    upload : File.File -> Cmd Msg
    upload file =
      Http.request
        { method = "PUT"
        , headers = []
        , url = "https://example.com/publish"
        , body = Http.fileBody file
        , expect = Http.expectWhatever Uploaded
        , timeout = Nothing
        , tracker = Nothing
        }

It lets you set custom `headers` as needed. The `timeout` is the number of
milliseconds you are willing to wait before giving up. The `tracker` lets you
[`cancel`](#cancel) and [`track`](#track) requests.
-}
request :
    { method : Elm.Expression
    , headers : Elm.Expression
    , url : Elm.Expression
    , body : Elm.Expression
    , expect : Elm.Expression
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
request arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "request"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ Elm.record
            [ Elm.field "method" arg1.method
            , Elm.field "headers" arg1.headers
            , Elm.field "url" arg1.url
            , Elm.field "body" arg1.body
            , Elm.field "expect" arg1.expect
            , Elm.field "timeout" arg1.timeout
            , Elm.field "tracker" arg1.tracker
            ]
        ]


{-| Create a `Header`.

    header "If-Modified-Since" "Sat 29 Oct 1994 19:43:31 GMT"
    header "Max-Forwards" "10"
    header "X-Requested-With" "XMLHttpRequest"
-}
header : Elm.Expression -> Elm.Expression -> Elm.Expression
header arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "header"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "Http" ] "Header" [])
            )
        )
        [ arg1, arg2 ]


{-| Create an empty body for your `Request`. This is useful for GET requests
and POST requests where you are not sending any data.
-}
emptyBody : Elm.Expression
emptyBody =
    Elm.valueWith moduleName_ "emptyBody" (Type.namedWith [ "Http" ] "Body" [])


{-| Put some string in the body of your `Request`. Defining `jsonBody` looks
like this:

    import Json.Encode as Encode

    jsonBody : Encode.Value -> Body
    jsonBody value =
      stringBody "application/json" (Encode.encode 0 value)

The first argument is a [MIME type](https://en.wikipedia.org/wiki/Media_type)
of the body. Some servers are strict about this!
-}
stringBody : Elm.Expression -> Elm.Expression -> Elm.Expression
stringBody arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "stringBody"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
        )
        [ arg1, arg2 ]


{-| Put some JSON value in the body of your `Request`. This will automatically
add the `Content-Type: application/json` header.
-}
jsonBody : Elm.Expression -> Elm.Expression
jsonBody arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "jsonBody"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [] ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
        )
        [ arg1 ]


{-| Use a file as the body of your `Request`. When someone uploads an image
into the browser with [`elm/file`](/packages/elm/file/latest) you can forward
it to a server.

This will automatically set the `Content-Type` to the MIME type of the file.

**Note:** Use [`track`](#track) to track upload progress.
-}
fileBody : Elm.Expression -> Elm.Expression
fileBody arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fileBody"
            (Type.function
                [ Type.namedWith [ "File" ] "File" [] ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
        )
        [ arg1 ]


{-| Put some `Bytes` in the body of your `Request`. This allows you to use
[`elm/bytes`](/packages/elm/bytes/latest) to have full control over the binary
representation of the data you are sending. For example, you could create an
`archive.zip` file and send it along like this:

    import Bytes exposing (Bytes)

    zipBody : Bytes -> Body
    zipBody bytes =
      bytesBody "application/zip" bytes

The first argument is a [MIME type](https://en.wikipedia.org/wiki/Media_type)
of the body. In other scenarios you may want to use MIME types like `image/png`
or `image/jpeg` instead.

**Note:** Use [`track`](#track) to track upload progress.
-}
bytesBody : Elm.Expression -> Elm.Expression -> Elm.Expression
bytesBody arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "bytesBody"
            (Type.function
                [ Type.string, Type.namedWith [ "Bytes" ] "Bytes" [] ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
        )
        [ arg1, arg2 ]


{-| When someone clicks submit on the `<form>`, browsers send a special HTTP
request with all the form data. Something like this:

```
POST /test.html HTTP/1.1
Host: example.org
Content-Type: multipart/form-data;boundary="7MA4YWxkTrZu0gW"

--7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="title"

Trip to London
--7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="album[]"; filename="parliment.jpg"

...RAW...IMAGE...BITS...
--7MA4YWxkTrZu0gW--
```

This was the only way to send files for a long time, so many servers expect
data in this format. **The `multipartBody` function lets you create these
requests.** For example, to upload a photo album all at once, you could create
a body like this:

    multipartBody
      [ stringPart "title" "Trip to London"
      , filePart "album[]" file1
      , filePart "album[]" file2
      , filePart "album[]" file3
      ]

All of the body parts need to have a name. Names can be repeated. Adding the
`[]` on repeated names is a convention from PHP. It seems weird, but I see it
enough to mention it. You do not have to do it that way, especially if your
server uses some other convention!

The `Content-Type: multipart/form-data` header is automatically set when
creating a body this way.

**Note:** Use [`track`](#track) to track upload progress.
-}
multipartBody : List Elm.Expression -> Elm.Expression
multipartBody arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "multipartBody"
            (Type.function
                [ Type.list (Type.namedWith [ "Http" ] "Part" []) ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
        )
        [ Elm.list arg1 ]


{-| A part that contains `String` data.

    multipartBody
      [ stringPart "title" "Tom"
      , filePart "photo" tomPng
      ]
-}
stringPart : Elm.Expression -> Elm.Expression -> Elm.Expression
stringPart arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "stringPart"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "Http" ] "Part" [])
            )
        )
        [ arg1, arg2 ]


{-| A part that contains a file. You can use
[`elm/file`](/packages/elm/file/latest) to get files loaded into the
browser. From there, you can send it along to a server like this:

    multipartBody
      [ stringPart "product" "Ikea Bekant"
      , stringPart "description" "Great desk for home office."
      , filePart "image[]" file1
      , filePart "image[]" file2
      , filePart "image[]" file3
      ]
-}
filePart : Elm.Expression -> Elm.Expression -> Elm.Expression
filePart arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "filePart"
            (Type.function
                [ Type.string, Type.namedWith [ "File" ] "File" [] ]
                (Type.namedWith [ "Http" ] "Part" [])
            )
        )
        [ arg1, arg2 ]


{-| A part that contains bytes, allowing you to use
[`elm/bytes`](/packages/elm/bytes/latest) to encode data exactly in the format
you need.

    multipartBody
      [ stringPart "title" "Tom"
      , bytesPart "photo" "image/png" bytes
      ]

**Note:** You must provide a MIME type so that the receiver has clues about
how to interpret the bytes.
-}
bytesPart : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
bytesPart arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "bytesPart"
            (Type.function
                [ Type.string
                , Type.string
                , Type.namedWith [ "Bytes" ] "Bytes" []
                ]
                (Type.namedWith [ "Http" ] "Part" [])
            )
        )
        [ arg1, arg2, arg3 ]


{-| Expect the response body to be a `String`. Like when getting the full text
of a book:

    import Http

    type Msg
      = GotText (Result Http.Error String)

    getPublicOpinion : Cmd Msg
    getPublicOpinion =
      Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }

The response body is always some sequence of bytes, but in this case, we
expect it to be UTF-8 encoded text that can be turned into a `String`.
-}
expectString : (Elm.Expression -> Elm.Expression) -> Elm.Expression
expectString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectString"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.string ]
                    ]
                    (Type.var "msg")
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass ]


{-| Expect the response body to be JSON. Like if you want to get a random cat
GIF you might say:

    import Http
    import Json.Decode exposing (Decoder, field, string)

    type Msg
      = GotGif (Result Http.Error String)

    getRandomCatGif : Cmd Msg
    getRandomCatGif =
      Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }

    gifDecoder : Decoder String
    gifDecoder =
      field "data" (field "image_url" string)

The official guide goes through this particular example [here][]. That page
also introduces [`elm/json`][json] to help you get started turning JSON into
Elm values in other situations.

[here]: https://guide.elm-lang.org/interop/json.html
[json]: /packages/elm/json/latest/

If the JSON decoder fails, you get a `BadBody` error that tries to explain
what went wrong.
-}
expectJson :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
expectJson arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectJson"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.var "a" ]
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Expect the response body to be binary data. For example, maybe you are
talking to an endpoint that gives back ProtoBuf data:

    import Bytes.Decode as Bytes
    import Http

    type Msg
      = GotData (Result Http.Error Data)

    getData : Cmd Msg
    getData =
      Http.get
        { url = "/data"
        , expect = Http.expectBytes GotData dataDecoder
        }

    -- dataDecoder : Bytes.Decoder Data

You would use [`elm/bytes`](/packages/elm/bytes/latest/) to decode the binary
data according to a proto definition file like `example.proto`.

If the decoder fails, you get a `BadBody` error that just indicates that
_something_ went wrong. It probably makes sense to debug by peeking at the
bytes you are getting in the browser developer tools or something.
-}
expectBytes :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
expectBytes arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectBytes"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.namedWith
                    [ "Bytes", "Decode" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Expect the response body to be whatever. It does not matter. Ignore it!
For example, you might want this when uploading files:

    import Http

    type Msg
      = Uploaded (Result Http.Error ())

    upload : File -> Cmd Msg
    upload file =
      Http.post
        { url = "/upload"
        , body = Http.fileBody file
        , expect = Http.expectWhatever Uploaded
        }

The server may be giving back a response body, but we do not care about it.
-}
expectWhatever : (Elm.Expression -> Elm.Expression) -> Elm.Expression
expectWhatever arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectWhatever"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.unit ]
                    ]
                    (Type.var "msg")
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass ]


{-| Track the progress of a request. Create a [`request`](#request) where
`tracker = Just "form.pdf"` and you can track it with a subscription like
`track "form.pdf" GotProgress`.
-}
track : Elm.Expression -> (Elm.Expression -> Elm.Expression) -> Elm.Expression
track arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "track"
            (Type.function
                [ Type.string
                , Type.function
                    [ Type.namedWith [ "Http" ] "Progress" [] ]
                    (Type.var "msg")
                ]
                (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])
            )
        )
        [ arg1, arg2 Elm.pass ]


{-| Turn `Sending` progress into a useful fraction.

    fractionSent { sent =   0, size = 1024 } == 0.0
    fractionSent { sent = 256, size = 1024 } == 0.25
    fractionSent { sent = 512, size = 1024 } == 0.5

    -- fractionSent { sent = 0, size = 0 } == 1.0

The result is always between `0.0` and `1.0`, ensuring that any progress bar
animations never go out of bounds.

And notice that `size` can be zero. That means you are sending a request with
an empty body. Very common! When `size` is zero, the result is always `1.0`.

**Note:** If you create your own function to compute this fraction, watch out
for divide-by-zero errors!
-}
fractionSent :
    { sent : Elm.Expression, size : Elm.Expression } -> Elm.Expression
fractionSent arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fractionSent"
            (Type.function
                [ Type.record [ ( "sent", Type.int ), ( "size", Type.int ) ] ]
                Type.float
            )
        )
        [ Elm.record [ Elm.field "sent" arg1.sent, Elm.field "size" arg1.size ]
        ]


{-| Turn `Receiving` progress into a useful fraction for progress bars.

    fractionReceived { received =   0, size = Just 1024 } == 0.0
    fractionReceived { received = 256, size = Just 1024 } == 0.25
    fractionReceived { received = 512, size = Just 1024 } == 0.5

    -- fractionReceived { received =   0, size = Nothing } == 0.0
    -- fractionReceived { received = 256, size = Nothing } == 0.0
    -- fractionReceived { received = 512, size = Nothing } == 0.0

The `size` here is based on the [`Content-Length`][cl] header which may be
missing in some cases. A server may be misconfigured or it may be streaming
data and not actually know the final size. Whatever the case, this function
will always give `0.0` when the final size is unknown.

Furthermore, the `Content-Length` header may be incorrect! The implementation
clamps the fraction between `0.0` and `1.0`, so you will just get `1.0` if
you ever receive more bytes than promised.

**Note:** If you are streaming something, you can write a custom version of
this function that just tracks bytes received. Maybe you show that 22kb or 83kb
have been downloaded, without a specific fraction. If you do this, be wary of
divide-by-zero errors because `size` can always be zero!

[cl]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Length
-}
fractionReceived :
    { received : Elm.Expression, size : Elm.Expression } -> Elm.Expression
fractionReceived arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fractionReceived"
            (Type.function
                [ Type.record
                    [ ( "received", Type.int )
                    , ( "size", Type.maybe Type.int )
                    ]
                ]
                Type.float
            )
        )
        [ Elm.record
            [ Elm.field "received" arg1.received, Elm.field "size" arg1.size ]
        ]


{-| Try to cancel an ongoing request based on a `tracker`.
-}
cancel : Elm.Expression -> Elm.Expression
cancel arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "cancel"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ arg1 ]


{-| Create a request with a risky security policy. Things like:

- Allow responses from other domains to set cookies.
- Include cookies in requests to other domains.

This is called [`withCredentials`][wc] in JavaScript, and it allows a couple
other risky things as well. It can be useful if `www.example.com` needs to
talk to `uploads.example.com`, but it should be used very carefully!

For example, every HTTP request includes a `Host` header revealing the domain,
so any request to `facebook.com` reveals the website that sent it. From there,
cookies can be used to correlate browsing habits with specific users. “Oh, it
looks like they visited `example.com`. Maybe they want ads about examples!”
This is why you can get shoe ads for months without saying anything about it
on any social networks. **This risk exists even for people who do not have an
account.** Servers can set a new cookie to uniquely identify the browser and
build a profile around that. Same kind of tricks for logged out users.

**Context:** A significantly worse version of this can happen when trying to
add integrations with Google, Facebook, Pinterest, Twitter, etc. “Add our share
button. It is super easy. Just add this `<script>` tag!” But the goal here is
to get _arbitrary_ access to the executing context. Now they can track clicks,
read page content, use time zones to approximate location, etc. As of this
writing, suggesting that developers just embed `<script>` tags is the default
for Google Analytics, Facebook Like Buttons, Twitter Follow Buttons, Pinterest
Save Buttons, and Instagram Embeds.

[ah]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization
[wc]: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/withCredentials
-}
riskyRequest :
    { method : Elm.Expression
    , headers : Elm.Expression
    , url : Elm.Expression
    , body : Elm.Expression
    , expect : Elm.Expression
    , timeout : Elm.Expression
    , tracker : Elm.Expression
    }
    -> Elm.Expression
riskyRequest arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "riskyRequest"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ Elm.record
            [ Elm.field "method" arg1.method
            , Elm.field "headers" arg1.headers
            , Elm.field "url" arg1.url
            , Elm.field "body" arg1.body
            , Elm.field "expect" arg1.expect
            , Elm.field "timeout" arg1.timeout
            , Elm.field "tracker" arg1.tracker
            ]
        ]


{-| Expect a [`Response`](#Response) with a `String` body. So you could define
your own [`expectJson`](#expectJson) like this:

    import Http
    import Json.Decode as D

    expectJson : (Result Http.Error a -> msg) -> D.Decoder a -> Expect msg
    expectJson toMsg decoder =
      expectStringResponse toMsg <|
        \response ->
          case response of
            Http.BadUrl_ url ->
              Err (Http.BadUrl url)

            Http.Timeout_ ->
              Err Http.Timeout

            Http.NetworkError_ ->
              Err Http.NetworkError

            Http.BadStatus_ metadata body ->
              Err (Http.BadStatus metadata.statusCode)

            Http.GoodStatus_ metadata body ->
              case D.decodeString decoder body of
                Ok value ->
                  Ok value

                Err err ->
                  Err (Http.BadBody (D.errorToString err))

This function is great for fancier error handling and getting response headers.
For example, maybe when your sever gives a 404 status code (not found) it also
provides a helpful JSON message in the response body. This function lets you
add logic to the `BadStatus_` branch so you can parse that JSON and give users
a more helpful message! Or make your own custom error type for your particular
application!
-}
expectStringResponse :
    (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
expectStringResponse arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectStringResponse"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.function
                    [ Type.namedWith [ "Http" ] "Response" [ Type.string ] ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass, arg2 Elm.pass ]


{-| Expect a [`Response`](#Response) with a `Bytes` body.

It works just like [`expectStringResponse`](#expectStringResponse), giving you
more access to headers and more leeway in defining your own errors.
-}
expectBytesResponse :
    (Elm.Expression -> Elm.Expression)
    -> (Elm.Expression -> Elm.Expression)
    -> Elm.Expression
expectBytesResponse arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectBytesResponse"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.function
                    [ Type.namedWith
                        [ "Http" ]
                        "Response"
                        [ Type.namedWith [ "Bytes" ] "Bytes" [] ]
                    ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass, arg2 Elm.pass ]


{-| Just like [`request`](#request), but it creates a `Task`. This makes it
possible to pair your HTTP request with `Time.now` if you need timestamps for
some reason. **This should be quite rare.**
-}
task :
    { method : Elm.Expression
    , headers : Elm.Expression
    , url : Elm.Expression
    , body : Elm.Expression
    , resolver : Elm.Expression
    , timeout : Elm.Expression
    }
    -> Elm.Expression
task arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "task"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "resolver"
                      , Type.namedWith
                            [ "Http" ]
                            "Resolver"
                            [ Type.var "x", Type.var "a" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
        )
        [ Elm.record
            [ Elm.field "method" arg1.method
            , Elm.field "headers" arg1.headers
            , Elm.field "url" arg1.url
            , Elm.field "body" arg1.body
            , Elm.field "resolver" arg1.resolver
            , Elm.field "timeout" arg1.timeout
            ]
        ]


{-| Turn a response with a `String` body into a result.
Similar to [`expectStringResponse`](#expectStringResponse).
-}
stringResolver : (Elm.Expression -> Elm.Expression) -> Elm.Expression
stringResolver arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "stringResolver"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Http" ] "Response" [ Type.string ] ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "Http" ]
                    "Resolver"
                    [ Type.var "x", Type.var "a" ]
                )
            )
        )
        [ arg1 Elm.pass ]


{-| Turn a response with a `Bytes` body into a result.
Similar to [`expectBytesResponse`](#expectBytesResponse).
-}
bytesResolver : (Elm.Expression -> Elm.Expression) -> Elm.Expression
bytesResolver arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "bytesResolver"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Http" ]
                        "Response"
                        [ Type.namedWith [ "Bytes" ] "Bytes" [] ]
                    ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "Http" ]
                    "Resolver"
                    [ Type.var "x", Type.var "a" ]
                )
            )
        )
        [ arg1 Elm.pass ]


{-| Just like [`riskyRequest`](#riskyRequest), but it creates a `Task`. **Use
with caution!** This has all the same security concerns as `riskyRequest`.
-}
riskyTask :
    { method : Elm.Expression
    , headers : Elm.Expression
    , url : Elm.Expression
    , body : Elm.Expression
    , resolver : Elm.Expression
    , timeout : Elm.Expression
    }
    -> Elm.Expression
riskyTask arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "riskyTask"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "resolver"
                      , Type.namedWith
                            [ "Http" ]
                            "Resolver"
                            [ Type.var "x", Type.var "a" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
        )
        [ Elm.record
            [ Elm.field "method" arg1.method
            , Elm.field "headers" arg1.headers
            , Elm.field "url" arg1.url
            , Elm.field "body" arg1.body
            , Elm.field "resolver" arg1.resolver
            , Elm.field "timeout" arg1.timeout
            ]
        ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { get : Elm.Expression
    , post : Elm.Expression
    , request : Elm.Expression
    , header : Elm.Expression
    , emptyBody : Elm.Expression
    , stringBody : Elm.Expression
    , jsonBody : Elm.Expression
    , fileBody : Elm.Expression
    , bytesBody : Elm.Expression
    , multipartBody : Elm.Expression
    , stringPart : Elm.Expression
    , filePart : Elm.Expression
    , bytesPart : Elm.Expression
    , expectString : Elm.Expression
    , expectJson : Elm.Expression
    , expectBytes : Elm.Expression
    , expectWhatever : Elm.Expression
    , track : Elm.Expression
    , fractionSent : Elm.Expression
    , fractionReceived : Elm.Expression
    , cancel : Elm.Expression
    , riskyRequest : Elm.Expression
    , expectStringResponse : Elm.Expression
    , expectBytesResponse : Elm.Expression
    , task : Elm.Expression
    , stringResolver : Elm.Expression
    , bytesResolver : Elm.Expression
    , riskyTask : Elm.Expression
    }
id_ =
    { get =
        Elm.valueWith
            moduleName_
            "get"
            (Type.function
                [ Type.record
                    [ ( "url", Type.string )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , post =
        Elm.valueWith
            moduleName_
            "post"
            (Type.function
                [ Type.record
                    [ ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , request =
        Elm.valueWith
            moduleName_
            "request"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , header =
        Elm.valueWith
            moduleName_
            "header"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "Http" ] "Header" [])
            )
    , emptyBody =
        Elm.valueWith
            moduleName_
            "emptyBody"
            (Type.namedWith [ "Http" ] "Body" [])
    , stringBody =
        Elm.valueWith
            moduleName_
            "stringBody"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
    , jsonBody =
        Elm.valueWith
            moduleName_
            "jsonBody"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [] ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
    , fileBody =
        Elm.valueWith
            moduleName_
            "fileBody"
            (Type.function
                [ Type.namedWith [ "File" ] "File" [] ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
    , bytesBody =
        Elm.valueWith
            moduleName_
            "bytesBody"
            (Type.function
                [ Type.string, Type.namedWith [ "Bytes" ] "Bytes" [] ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
    , multipartBody =
        Elm.valueWith
            moduleName_
            "multipartBody"
            (Type.function
                [ Type.list (Type.namedWith [ "Http" ] "Part" []) ]
                (Type.namedWith [ "Http" ] "Body" [])
            )
    , stringPart =
        Elm.valueWith
            moduleName_
            "stringPart"
            (Type.function
                [ Type.string, Type.string ]
                (Type.namedWith [ "Http" ] "Part" [])
            )
    , filePart =
        Elm.valueWith
            moduleName_
            "filePart"
            (Type.function
                [ Type.string, Type.namedWith [ "File" ] "File" [] ]
                (Type.namedWith [ "Http" ] "Part" [])
            )
    , bytesPart =
        Elm.valueWith
            moduleName_
            "bytesPart"
            (Type.function
                [ Type.string
                , Type.string
                , Type.namedWith [ "Bytes" ] "Bytes" []
                ]
                (Type.namedWith [ "Http" ] "Part" [])
            )
    , expectString =
        Elm.valueWith
            moduleName_
            "expectString"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.string ]
                    ]
                    (Type.var "msg")
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
    , expectJson =
        Elm.valueWith
            moduleName_
            "expectJson"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.namedWith [ "Json", "Decode" ] "Decoder" [ Type.var "a" ]
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
    , expectBytes =
        Elm.valueWith
            moduleName_
            "expectBytes"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.namedWith
                    [ "Bytes", "Decode" ]
                    "Decoder"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
    , expectWhatever =
        Elm.valueWith
            moduleName_
            "expectWhatever"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.namedWith [ "Http" ] "Error" [], Type.unit ]
                    ]
                    (Type.var "msg")
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
    , track =
        Elm.valueWith
            moduleName_
            "track"
            (Type.function
                [ Type.string
                , Type.function
                    [ Type.namedWith [ "Http" ] "Progress" [] ]
                    (Type.var "msg")
                ]
                (Type.namedWith [ "Platform", "Sub" ] "Sub" [ Type.var "msg" ])
            )
    , fractionSent =
        Elm.valueWith
            moduleName_
            "fractionSent"
            (Type.function
                [ Type.record [ ( "sent", Type.int ), ( "size", Type.int ) ] ]
                Type.float
            )
    , fractionReceived =
        Elm.valueWith
            moduleName_
            "fractionReceived"
            (Type.function
                [ Type.record
                    [ ( "received", Type.int )
                    , ( "size", Type.maybe Type.int )
                    ]
                ]
                Type.float
            )
    , cancel =
        Elm.valueWith
            moduleName_
            "cancel"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , riskyRequest =
        Elm.valueWith
            moduleName_
            "riskyRequest"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "expect"
                      , Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    , ( "tracker", Type.maybe Type.string )
                    ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , expectStringResponse =
        Elm.valueWith
            moduleName_
            "expectStringResponse"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.function
                    [ Type.namedWith [ "Http" ] "Response" [ Type.string ] ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
    , expectBytesResponse =
        Elm.valueWith
            moduleName_
            "expectBytesResponse"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.function
                    [ Type.namedWith
                        [ "Http" ]
                        "Response"
                        [ Type.namedWith [ "Bytes" ] "Bytes" [] ]
                    ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith [ "Http" ] "Expect" [ Type.var "msg" ])
            )
    , task =
        Elm.valueWith
            moduleName_
            "task"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "resolver"
                      , Type.namedWith
                            [ "Http" ]
                            "Resolver"
                            [ Type.var "x", Type.var "a" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
    , stringResolver =
        Elm.valueWith
            moduleName_
            "stringResolver"
            (Type.function
                [ Type.function
                    [ Type.namedWith [ "Http" ] "Response" [ Type.string ] ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "Http" ]
                    "Resolver"
                    [ Type.var "x", Type.var "a" ]
                )
            )
    , bytesResolver =
        Elm.valueWith
            moduleName_
            "bytesResolver"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Http" ]
                        "Response"
                        [ Type.namedWith [ "Bytes" ] "Bytes" [] ]
                    ]
                    (Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "Http" ]
                    "Resolver"
                    [ Type.var "x", Type.var "a" ]
                )
            )
    , riskyTask =
        Elm.valueWith
            moduleName_
            "riskyTask"
            (Type.function
                [ Type.record
                    [ ( "method", Type.string )
                    , ( "headers"
                      , Type.list (Type.namedWith [ "Http" ] "Header" [])
                      )
                    , ( "url", Type.string )
                    , ( "body", Type.namedWith [ "Http" ] "Body" [] )
                    , ( "resolver"
                      , Type.namedWith
                            [ "Http" ]
                            "Resolver"
                            [ Type.var "x", Type.var "a" ]
                      )
                    , ( "timeout", Type.maybe Type.float )
                    ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
    }


