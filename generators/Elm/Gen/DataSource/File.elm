module Elm.Gen.DataSource.File exposing (bodyWithFrontmatter, bodyWithoutFrontmatter, id_, jsonFile, make_, moduleName_, onlyFrontmatter, rawFile, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "DataSource", "File" ]


types_ : {}
types_ =
    {}


make_ : {}
make_ =
    {}


{-|

    import DataSource exposing (DataSource)
    import DataSource.File as File
    import OptimizedDecoder as Decode exposing (Decoder)

    blogPost : DataSource BlogPostMetadata
    blogPost =
        File.bodyWithFrontmatter blogPostDecoder
            "blog/hello-world.md"

    type alias BlogPostMetadata =
        { body : String
        , title : String
        , tags : List String
        }

    blogPostDecoder : String -> Decoder BlogPostMetadata
    blogPostDecoder body =
        Decode.map2 (BlogPostMetadata body)
            (Decode.field "title" Decode.string)
            (Decode.field "tags" tagsDecoder)

    tagsDecoder : Decoder (List String)
    tagsDecoder =
        Decode.map (String.split " ")
            Decode.string

This will give us a DataSource that results in the following value:

    value =
        { body = "Hey there! This is my first post :)"
        , title = "Hello, World!"
        , tags = [ "elm" ]
        }

It's common to parse the body with a markdown parser or other format.

    import DataSource exposing (DataSource)
    import DataSource.File as File
    import Html exposing (Html)
    import OptimizedDecoder as Decode exposing (Decoder)

    example :
        DataSource
            { title : String
            , body : List (Html msg)
            }
    example =
        File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map2
                    (\title renderedMarkdown ->
                        { title = title
                        , body = renderedMarkdown
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (markdownString
                        |> markdownToView
                        |> Decode.fromResult
                    )
            )
            "foo.md"

    markdownToView :
        String
        -> Result String (List (Html msg))
    markdownToView markdownString =
        markdownString
            |> Markdown.Parser.parse
            |> Result.mapError (\_ -> "Markdown error.")
            |> Result.andThen
                (\blocks ->
                    Markdown.Renderer.render
                        Markdown.Renderer.defaultHtmlRenderer
                        blocks
                )

-}
bodyWithFrontmatter :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
bodyWithFrontmatter arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "bodyWithFrontmatter"
            (Type.function
                [ Type.function
                    [ Type.string ]
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "frontmatter" ]
                    )
                , Type.string
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "frontmatter" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Same as `bodyWithFrontmatter` except it doesn't include the frontmatter.

For example, if you have a file called `blog/hello-world.md` with

```markdown
---
title: Hello, World!
tags: elm
---
Hey there! This is my first post :)
```

    import DataSource exposing (DataSource)

    data : DataSource String
    data =
        bodyWithoutFrontmatter "blog/hello-world.md"

Then data will yield the value `"Hey there! This is my first post :)"`.

-}
bodyWithoutFrontmatter : Elm.Expression -> Elm.Expression
bodyWithoutFrontmatter arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "bodyWithoutFrontmatter"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.string ])
            )
        )
        [ arg1 ]


{-| Same as `bodyWithFrontmatter` except it doesn't include the body.

This is often useful when you're aggregating data, for example getting a listing of blog posts and need to extract
just the metadata.

    import DataSource exposing (DataSource)
    import DataSource.File as File
    import OptimizedDecoder as Decode exposing (Decoder)

    blogPost : DataSource BlogPostMetadata
    blogPost =
        File.onlyFrontmatter "blog/hello-world.md"
            blogPostDecoder

    type alias BlogPostMetadata =
        { title : String
        , tags : List String
        }

    blogPostDecoder : Decoder BlogPostMetadata
    blogPostDecoder =
        Decode.map2 BlogPostMetadata
            (Decode.field "title" Decode.string)
            (Decode.field "tags" (Decode.list Decode.string))

If you wanted to use this to get this metadata for all blog posts in a folder, you could use
the [`DataSource`](DataSource) API along with [`DataSource.Glob`](DataSource.Glob).

    import DataSource exposing (DataSource)
    import DataSource.File as File
    import OptimizedDecoder as Decode exposing (Decoder)

    blogPostFiles : DataSource (List String)
    blogPostFiles =
        Glob.succeed identity
            |> Glob.captureFilePath
            |> Glob.match (Glob.literal "content/blog/")
            |> Glob.match Glob.wildcard
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource

    allMetadata : DataSource (List BlogPostMetadata)
    allMetadata =
        blogPostFiles
            |> DataSource.map
                (List.map
                    (File.onlyFrontmatter
                        blogPostDecoder
                    )
                )
            |> DataSource.resolve

-}
onlyFrontmatter : Elm.Expression -> Elm.Expression -> Elm.Expression
onlyFrontmatter arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "onlyFrontmatter"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "frontmatter" ]
                , Type.string
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "frontmatter" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Read a file as JSON.

The OptimizedDecoder will strip off any unused JSON data.

    import DataSource exposing (DataSource)
    import DataSource.File as File

    sourceDirectories : DataSource (List String)
    sourceDirectories =
        File.jsonFile
            (Decode.field
                "source-directories"
                (Decode.list Decode.string)
            )
            "elm.json"

-}
jsonFile : Elm.Expression -> Elm.Expression -> Elm.Expression
jsonFile arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "jsonFile"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.string
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
        )
        [ arg1, arg2 ]


{-| Get the raw file content. Unlike the frontmatter helpers in this module, this function will not strip off frontmatter if there is any.

This is the function you want if you are reading in a file directly. For example, if you read in a CSV file, a raw text file, or any other file that doesn't
have frontmatter.

There's a special function for reading in JSON files, [`jsonFile`](#jsonFile). If you're reading a JSON file then be sure to
use `jsonFile` to get the benefits of the `OptimizedDecoder` here.

You could read a file called `hello.txt` in your root project directory like this:

    import DataSource exposing (DataSource)
    import DataSource.File as File

    elmJsonFile : DataSource String
    elmJsonFile =
        File.rawFile "hello.txt"

-}
rawFile : Elm.Expression -> Elm.Expression
rawFile arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "rawFile"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.string ])
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { bodyWithFrontmatter : Elm.Expression
    , bodyWithoutFrontmatter : Elm.Expression
    , onlyFrontmatter : Elm.Expression
    , jsonFile : Elm.Expression
    , rawFile : Elm.Expression
    }
id_ =
    { bodyWithFrontmatter =
        Elm.valueWith
            moduleName_
            "bodyWithFrontmatter"
            (Type.function
                [ Type.function
                    [ Type.string ]
                    (Type.namedWith
                        [ "OptimizedDecoder" ]
                        "Decoder"
                        [ Type.var "frontmatter" ]
                    )
                , Type.string
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "frontmatter" ]
                )
            )
    , bodyWithoutFrontmatter =
        Elm.valueWith
            moduleName_
            "bodyWithoutFrontmatter"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.string ])
            )
    , onlyFrontmatter =
        Elm.valueWith
            moduleName_
            "onlyFrontmatter"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "frontmatter" ]
                , Type.string
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.var "frontmatter" ]
                )
            )
    , jsonFile =
        Elm.valueWith
            moduleName_
            "jsonFile"
            (Type.function
                [ Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "a" ]
                , Type.string
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
    , rawFile =
        Elm.valueWith
            moduleName_
            "rawFile"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.string ])
            )
    }


