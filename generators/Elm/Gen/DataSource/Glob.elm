module Elm.Gen.DataSource.Glob exposing (atLeastOne, capture, captureFilePath, digits, expectUniqueMatch, id_, int, literal, make_, map, match, moduleName_, oneOf, recursiveWildcard, succeed, toDataSource, types_, wildcard, zeroOrMore)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "DataSource", "Glob" ]


types_ : { glob : Type.Annotation -> Type.Annotation }
types_ =
    { glob = \arg0 -> Type.namedWith moduleName_ "Glob" [ arg0 ] }


make_ : {}
make_ =
    {}


{-| Adds on to the glob pattern, and captures it in the resulting Elm match value. That means this both changes which
files will match, and gives you the sub-match as Elm data for each matching file.

Exactly the same as `match` except it also captures the matched sub-pattern.

    type alias ArchivesArticle =
        { year : String
        , month : String
        , day : String
        , slug : String
        }

    archives : DataSource ArchivesArticle
    archives =
        Glob.succeed ArchivesArticle
            |> Glob.match (Glob.literal "archive/")
            |> Glob.capture Glob.int
            |> Glob.match (Glob.literal "/")
            |> Glob.capture Glob.int
            |> Glob.match (Glob.literal "/")
            |> Glob.capture Glob.int
            |> Glob.match (Glob.literal "/")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource

The file `archive/1977/06/10/apple-2-released.md` will give us this match:

    matches : List ArchivesArticle
    matches =
        DataSource.succeed
            [ { year = 1977
              , month = 6
              , day = 10
              , slug = "apple-2-released"
              }
            ]

When possible, it's best to grab data and turn it into structured Elm data when you have it. That way,
you don't end up with duplicate validation logic and data normalization, and your code will be more robust.

If you only care about getting the full matched file paths, you can use `match`. `capture` is very useful because
you can pick apart structured data as you build up your glob pattern. This follows the principle of
[Parse, Don't Validate](https://elm-radio.com/episode/parse-dont-validate/).

-}
capture : Elm.Expression -> Elm.Expression -> Elm.Expression
capture arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "capture"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.function [ Type.var "a" ] (Type.var "value") ]
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1, arg2 ]


{-| Adds on to the glob pattern, but does not capture it in the resulting Elm match value. That means this changes which
files will match, but does not change the Elm data type you get for each matching file.

Exactly the same as `capture` except it doesn't capture the matched sub-pattern.

-}
match : Elm.Expression -> Elm.Expression -> Elm.Expression
match arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "match"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1, arg2 ]


{-|

    import DataSource exposing (DataSource)
    import DataSource.Glob as Glob

    blogPosts :
        DataSource
            (List
                { filePath : String
                , slug : String
                }
            )
    blogPosts =
        Glob.succeed
            (\filePath slug ->
                { filePath = filePath
                , slug = slug
                }
            )
            |> Glob.captureFilePath
            |> Glob.match (Glob.literal "content/blog/")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource

This function does not change which files will or will not match. It just gives you the full matching
file path in your `Glob` pipeline.

Whenever possible, it's a good idea to use function to make sure you have an accurate file path when you need to read a file.

-}
captureFilePath : Elm.Expression -> Elm.Expression
captureFilePath arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "captureFilePath"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.function [ Type.string ] (Type.var "value") ]
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                )
            )
        )
        [ arg1 ]


{-| Matches anything except for a `/` in a file path. You may be familiar with this syntax from shells like bash
where you can run commands like `rm client/*.js` to remove all `.js` files in the `client` directory.

Just like a `*` glob pattern in bash, this `Glob.wildcard` function will only match within a path part. If you need to
match 0 or more path parts like, see `recursiveWildcard`.

    import DataSource exposing (DataSource)
    import DataSource.Glob as Glob

    type alias BlogPost =
        { year : String
        , month : String
        , day : String
        , slug : String
        }

    example : DataSource (List BlogPost)
    example =
        Glob.succeed BlogPost
            |> Glob.match (Glob.literal "blog/")
            |> Glob.match Glob.wildcard
            |> Glob.match (Glob.literal "-")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal "-")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal "/")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource

```shell

- blog/
  - 2021-05-27/
    - first-post.md
```

That will match to:

    results : DataSource (List BlogPost)
    results =
        DataSource.succeed
            [ { year = "2021"
              , month = "05"
              , day = "27"
              , slug = "first-post"
              }
            ]

Note that we can "destructure" the date part of this file path in the format `yyyy-mm-dd`. The `wildcard` matches
will match _within_ a path part (think between the slashes of a file path). `recursiveWildcard` can match across path parts.

-}
wildcard : Elm.Expression
wildcard =
    Elm.valueWith
        moduleName_
        "wildcard"
        (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.string ])


{-| Matches any number of characters, including `/`, as long as it's the only thing in a path part.

In contrast, `wildcard` will never match `/`, so it only matches within a single path part.

This is the elm-pages equivalent of `**/*.txt` in standard shell syntax:

    import DataSource exposing (DataSource)
    import DataSource.Glob as Glob

    example : DataSource (List ( List String, String ))
    example =
        Glob.succeed Tuple.pair
            |> Glob.match (Glob.literal "articles/")
            |> Glob.capture Glob.recursiveWildcard
            |> Glob.match (Glob.literal "/")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal ".txt")
            |> Glob.toDataSource

With these files:

```shell
- articles/
  - google-io-2021-recap.txt
  - archive/
    - 1977/
      - 06/
        - 10/
          - apple-2-announced.txt
```

We would get the following matches:

    matches : DataSource (List ( List String, String ))
    matches =
        DataSource.succeed
            [ ( [ "archive", "1977", "06", "10" ], "apple-2-announced" )
            , ( [], "google-io-2021-recap" )
            ]

Note that the recursive wildcard conveniently gives us a `List String`, where
each String is a path part with no slashes (like `archive`).

And also note that it matches 0 path parts into an empty list.

If we didn't include the `wildcard` after the `recursiveWildcard`, then we would only get
a single level of matches because it is followed by a file extension.

    example : DataSource (List String)
    example =
        Glob.succeed identity
            |> Glob.match (Glob.literal "articles/")
            |> Glob.capture Glob.recursiveWildcard
            |> Glob.match (Glob.literal ".txt")

    matches : DataSource (List String)
    matches =
        DataSource.succeed
            [ "google-io-2021-recap"
            ]

This is usually not what is intended. Using `recursiveWildcard` is usually followed by a `wildcard` for this reason.

-}
recursiveWildcard : Elm.Expression
recursiveWildcard =
    Elm.valueWith
        moduleName_
        "recursiveWildcard"
        (Type.namedWith
            [ "DataSource", "Glob" ]
            "Glob"
            [ Type.list Type.string ]
        )


{-| Same as [`digits`](#digits), but it safely turns the digits String into an `Int`.

Leading 0's are ignored.

    import DataSource exposing (DataSource)
    import DataSource.Glob as Glob

    slides : DataSource (List Int)
    slides =
        Glob.succeed identity
            |> Glob.match (Glob.literal "slide-")
            |> Glob.capture Glob.int
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource

With files

```shell
- slide-no-match.md
- slide-.md
- slide-1.md
- slide-01.md
- slide-2.md
- slide-03.md
- slide-4.md
- slide-05.md
- slide-06.md
- slide-007.md
- slide-08.md
- slide-09.md
- slide-10.md
- slide-11.md
```

Yields

    matches : DataSource (List Int)
    matches =
        DataSource.succeed
            [ 1
            , 1
            , 2
            , 3
            , 4
            , 5
            , 6
            , 7
            , 8
            , 9
            , 10
            , 11
            ]

Note that neither `slide-no-match.md` nor `slide-.md` match.
And both `slide-1.md` and `slide-01.md` match and turn into `1`.

-}
int : Elm.Expression
int =
    Elm.valueWith
        moduleName_
        "int"
        (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.int ])


{-| This is similar to [`wildcard`](#wildcard), but it will only match 1 or more digits (i.e. `[0-9]+`).

See [`int`](#int) for a convenience function to get an Int value instead of a String of digits.

-}
digits : Elm.Expression
digits =
    Elm.valueWith
        moduleName_
        "digits"
        (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.string ])


{-| Sometimes you want to make sure there is a unique file matching a particular pattern.
This is a simple helper that will give you a `DataSource` error if there isn't exactly 1 matching file.
If there is exactly 1, then you successfully get back that single match.

For example, maybe you can have

    import DataSource exposing (DataSource)
    import DataSource.Glob as Glob

    findBlogBySlug : String -> DataSource String
    findBlogBySlug slug =
        Glob.succeed identity
            |> Glob.captureFilePath
            |> Glob.match (Glob.literal "blog/")
            |> Glob.capture (Glob.literal slug)
            |> Glob.match
                (Glob.oneOf
                    ( ( "", () )
                    , [ ( "/index", () ) ]
                    )
                )
            |> Glob.match (Glob.literal ".md")
            |> Glob.expectUniqueMatch

If we used `findBlogBySlug "first-post"` with these files:

```markdown
- blog/
    - first-post/
        - index.md
```

This would give us:

    results : DataSource String
    results =
        DataSource.succeed "blog/first-post/index.md"

If we used `findBlogBySlug "first-post"` with these files:

```markdown
- blog/
    - first-post.md
    - first-post/
        - index.md
```

Then we will get a `DataSource` error saying `More than one file matched.` Keep in mind that `DataSource` failures
in build-time routes will cause a build failure, giving you the opportunity to fix the problem before users see the issue,
so it's ideal to make this kind of assertion rather than having fallback behavior that could silently cover up
issues (like if we had instead ignored the case where there are two or more matching blog post files).

-}
expectUniqueMatch : Elm.Expression -> Elm.Expression
expectUniqueMatch arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "expectUniqueMatch"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
        )
        [ arg1 ]


{-| Match a literal part of a path. Can include `/`s.

Some common uses include

  - The leading part of a pattern, to say "starts with `content/blog/`"
  - The ending part of a pattern, to say "ends with `.md`"
  - In-between wildcards, to say "these dynamic parts are separated by `/`"

```elm
import DataSource exposing (DataSource)
import DataSource.Glob as Glob

blogPosts =
    Glob.succeed
        (\section slug ->
            { section = section, slug = slug }
        )
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal "/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
```

-}
literal : Elm.Expression -> Elm.Expression
literal arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "literal"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.string ])
            )
        )
        [ arg1 ]


{-| A `Glob` can be mapped. This can be useful for transforming a sub-match in-place.

For example, if you wanted to take the slugs for a blog post and make sure they are normalized to be all lowercase, you
could use

    import DataSource exposing (DataSource)
    import DataSource.Glob as Glob

    blogPostsGlob : DataSource (List String)
    blogPostsGlob =
        Glob.succeed (\slug -> slug)
            |> Glob.match (Glob.literal "content/blog/")
            |> Glob.capture (Glob.wildcard |> Glob.map String.toLower)
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource

If you want to validate file formats, you can combine that with some `DataSource` helpers to turn a `Glob (Result String value)` into
a `DataSource (List value)`.

For example, you could take a date and parse it.

    import DataSource exposing (DataSource)
    import DataSource.Glob as Glob

    example : DataSource (List ( String, String ))
    example =
        Glob.succeed
            (\dateResult slug ->
                dateResult
                    |> Result.map (\okDate -> ( okDate, slug ))
            )
            |> Glob.match (Glob.literal "blog/")
            |> Glob.capture (Glob.recursiveWildcard |> Glob.map expectDateFormat)
            |> Glob.match (Glob.literal "/")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource
            |> DataSource.map (List.map DataSource.fromResult)
            |> DataSource.resolve

    expectDateFormat : List String -> Result String String
    expectDateFormat dateParts =
        case dateParts of
            [ year, month, date ] ->
                Ok (String.join "-" [ year, month, date ])

            _ ->
                Err "Unexpected date format, expected yyyy/mm/dd folder structure."

-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| `succeed` is how you start a pipeline for a `Glob`. You will need one argument for each `capture` in your `Glob`.
-}
succeed : Elm.Expression -> Elm.Expression
succeed arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "constructor" ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "constructor" ]
                )
            )
        )
        [ arg1 ]


{-| In order to get match data from your glob, turn it into a `DataSource` with this function.
-}
toDataSource : Elm.Expression -> Elm.Expression
toDataSource arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toDataSource"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list (Type.var "a") ]
                )
            )
        )
        [ arg1 ]


{-|

    import DataSource.Glob as Glob

    type Extension
        = Json
        | Yml

    type alias DataFile =
        { name : String
        , extension : String
        }

    dataFiles : DataSource (List DataFile)
    dataFiles =
        Glob.succeed DataFile
            |> Glob.match (Glob.literal "my-data/")
            |> Glob.capture Glob.wildcard
            |> Glob.match (Glob.literal ".")
            |> Glob.capture
                (Glob.oneOf
                    ( ( "yml", Yml )
                    , [ ( "json", Json )
                      ]
                    )
                )

If we have the following files

```shell
- my-data/
    - authors.yml
    - events.json
```

That gives us

    results : DataSource (List DataFile)
    results =
        DataSource.succeed
            [ { name = "authors"
              , extension = Yml
              }
            , { name = "events"
              , extension = Json
              }
            ]

You could also match an optional file path segment using `oneOf`.

    rootFilesMd : DataSource (List String)
    rootFilesMd =
        Glob.succeed (\slug -> slug)
            |> Glob.match (Glob.literal "blog/")
            |> Glob.capture Glob.wildcard
            |> Glob.match
                (Glob.oneOf
                    ( ( "", () )
                    , [ ( "/index", () ) ]
                    )
                )
            |> Glob.match (Glob.literal ".md")
            |> Glob.toDataSource

With these files:

```markdown
- blog/
    - first-post.md
    - second-post/
        - index.md
```

This would give us:

    results : DataSource (List String)
    results =
        DataSource.succeed
            [ "first-post"
            , "second-post"
            ]

-}
oneOf : Elm.Expression -> Elm.Expression
oneOf arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.tuple
                    (Type.tuple Type.string (Type.var "a"))
                    (Type.list (Type.tuple Type.string (Type.var "a")))
                ]
                (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| -}
zeroOrMore : List Elm.Expression -> Elm.Expression
zeroOrMore arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "zeroOrMore"
            (Type.function
                [ Type.list Type.string ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.maybe Type.string ]
                )
            )
        )
        [ Elm.list arg1 ]


{-| -}
atLeastOne : Elm.Expression -> Elm.Expression
atLeastOne arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "atLeastOne"
            (Type.function
                [ Type.tuple
                    (Type.tuple Type.string (Type.var "a"))
                    (Type.list (Type.tuple Type.string (Type.var "a")))
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.tuple (Type.var "a") (Type.list (Type.var "a")) ]
                )
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { capture : Elm.Expression
    , match : Elm.Expression
    , captureFilePath : Elm.Expression
    , wildcard : Elm.Expression
    , recursiveWildcard : Elm.Expression
    , int : Elm.Expression
    , digits : Elm.Expression
    , expectUniqueMatch : Elm.Expression
    , literal : Elm.Expression
    , map : Elm.Expression
    , succeed : Elm.Expression
    , toDataSource : Elm.Expression
    , oneOf : Elm.Expression
    , zeroOrMore : Elm.Expression
    , atLeastOne : Elm.Expression
    }
id_ =
    { capture =
        Elm.valueWith
            moduleName_
            "capture"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.function [ Type.var "a" ] (Type.var "value") ]
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                )
            )
    , match =
        Elm.valueWith
            moduleName_
            "match"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                , Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                )
            )
    , captureFilePath =
        Elm.valueWith
            moduleName_
            "captureFilePath"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.function [ Type.string ] (Type.var "value") ]
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "value" ]
                )
            )
    , wildcard =
        Elm.valueWith
            moduleName_
            "wildcard"
            (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.string ])
    , recursiveWildcard =
        Elm.valueWith
            moduleName_
            "recursiveWildcard"
            (Type.namedWith
                [ "DataSource", "Glob" ]
                "Glob"
                [ Type.list Type.string ]
            )
    , int =
        Elm.valueWith
            moduleName_
            "int"
            (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.int ])
    , digits =
        Elm.valueWith
            moduleName_
            "digits"
            (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.string ])
    , expectUniqueMatch =
        Elm.valueWith
            moduleName_
            "expectUniqueMatch"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "a" ])
            )
    , literal =
        Elm.valueWith
            moduleName_
            "literal"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.string ])
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                ]
                (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.var "b" ]
                )
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "constructor" ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "constructor" ]
                )
            )
    , toDataSource =
        Elm.valueWith
            moduleName_
            "toDataSource"
            (Type.function
                [ Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.var "a" ]
                ]
                (Type.namedWith
                    [ "DataSource" ]
                    "DataSource"
                    [ Type.list (Type.var "a") ]
                )
            )
    , oneOf =
        Elm.valueWith
            moduleName_
            "oneOf"
            (Type.function
                [ Type.tuple
                    (Type.tuple Type.string (Type.var "a"))
                    (Type.list (Type.tuple Type.string (Type.var "a")))
                ]
                (Type.namedWith [ "DataSource", "Glob" ] "Glob" [ Type.var "a" ]
                )
            )
    , zeroOrMore =
        Elm.valueWith
            moduleName_
            "zeroOrMore"
            (Type.function
                [ Type.list Type.string ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.maybe Type.string ]
                )
            )
    , atLeastOne =
        Elm.valueWith
            moduleName_
            "atLeastOne"
            (Type.function
                [ Type.tuple
                    (Type.tuple Type.string (Type.var "a"))
                    (Type.list (Type.tuple Type.string (Type.var "a")))
                ]
                (Type.namedWith
                    [ "DataSource", "Glob" ]
                    "Glob"
                    [ Type.tuple (Type.var "a") (Type.list (Type.var "a")) ]
                )
            )
    }


