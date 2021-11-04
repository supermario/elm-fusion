module Elm.Gen.Head.Seo exposing (article, audioPlayer, book, id_, make_, moduleName_, profile, song, summary, summaryLarge, types_, videoPlayer, website)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Head", "Seo" ]


types_ : { image : Type.Annotation, common : Type.Annotation }
types_ =
    { image = Type.named moduleName_ "Image"
    , common = Type.named moduleName_ "Common"
    }


make_ : {}
make_ =
    {}


{-| See <https://ogp.me/#type_article>
-}
article :
    { tags : Elm.Expression
    , section : Elm.Expression
    , publishedTime : Elm.Expression
    , modifiedTime : Elm.Expression
    , expirationTime : Elm.Expression
    }
    -> Elm.Expression
    -> Elm.Expression
article arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "article"
            (Type.function
                [ Type.record
                    [ ( "tags", Type.list Type.string )
                    , ( "section", Type.maybe Type.string )
                    , ( "publishedTime"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    , ( "modifiedTime"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    , ( "expirationTime"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    ]
                , Type.namedWith [ "Head", "Seo" ] "Common" []
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
        )
        [ Elm.record
            [ Elm.field "tags" arg1.tags
            , Elm.field "section" arg1.section
            , Elm.field "publishedTime" arg1.publishedTime
            , Elm.field "modifiedTime" arg1.modifiedTime
            , Elm.field "expirationTime" arg1.expirationTime
            ]
        , arg2
        ]


{-| Will be displayed as a Player card in twitter
See: <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/player-card>

OpenGraph audio will also be included.
The options will also be used to build up the appropriate OpenGraph `<meta>` tags.

-}
audioPlayer :
    { canonicalUrlOverride : Elm.Expression
    , siteName : Elm.Expression
    , image : Elm.Expression
    , description : Elm.Expression
    , title : Elm.Expression
    , audio : Elm.Expression
    , locale : Elm.Expression
    }
    -> Elm.Expression
audioPlayer arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "audioPlayer"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "audio", Type.namedWith [ "Head", "Seo" ] "Audio" [] )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
        )
        [ Elm.record
            [ Elm.field "canonicalUrlOverride" arg1.canonicalUrlOverride
            , Elm.field "siteName" arg1.siteName
            , Elm.field "image" arg1.image
            , Elm.field "description" arg1.description
            , Elm.field "title" arg1.title
            , Elm.field "audio" arg1.audio
            , Elm.field "locale" arg1.locale
            ]
        ]


{-| See <https://ogp.me/#type_book>
-}
book :
    Elm.Expression
    -> { tags : Elm.Expression
    , isbn : Elm.Expression
    , releaseDate : Elm.Expression
    }
    -> Elm.Expression
book arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "book"
            (Type.function
                [ Type.namedWith [ "Head", "Seo" ] "Common" []
                , Type.record
                    [ ( "tags", Type.list Type.string )
                    , ( "isbn", Type.maybe Type.string )
                    , ( "releaseDate"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    ]
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
        )
        [ arg1
        , Elm.record
            [ Elm.field "tags" arg2.tags
            , Elm.field "isbn" arg2.isbn
            , Elm.field "releaseDate" arg2.releaseDate
            ]
        ]


{-| See <https://ogp.me/#type_profile>
-}
profile :
    { firstName : Elm.Expression
    , lastName : Elm.Expression
    , username : Elm.Expression
    }
    -> Elm.Expression
    -> Elm.Expression
profile arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "profile"
            (Type.function
                [ Type.record
                    [ ( "firstName", Type.string )
                    , ( "lastName", Type.string )
                    , ( "username", Type.maybe Type.string )
                    ]
                , Type.namedWith [ "Head", "Seo" ] "Common" []
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
        )
        [ Elm.record
            [ Elm.field "firstName" arg1.firstName
            , Elm.field "lastName" arg1.lastName
            , Elm.field "username" arg1.username
            ]
        , arg2
        ]


{-| See <https://ogp.me/#type_music.song>
-}
song :
    Elm.Expression
    -> { duration : Elm.Expression
    , album : Elm.Expression
    , disc : Elm.Expression
    , track : Elm.Expression
    }
    -> Elm.Expression
song arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "song"
            (Type.function
                [ Type.namedWith [ "Head", "Seo" ] "Common" []
                , Type.record
                    [ ( "duration", Type.maybe Type.int )
                    , ( "album", Type.maybe Type.int )
                    , ( "disc", Type.maybe Type.int )
                    , ( "track", Type.maybe Type.int )
                    ]
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
        )
        [ arg1
        , Elm.record
            [ Elm.field "duration" arg2.duration
            , Elm.field "album" arg2.album
            , Elm.field "disc" arg2.disc
            , Elm.field "track" arg2.track
            ]
        ]


{-| Will be displayed as a large card in twitter
See: <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/summary>

The options will also be used to build up the appropriate OpenGraph `<meta>` tags.

Note: You cannot include audio or video tags with summaries.
If you want one of those, use `audioPlayer` or `videoPlayer`

-}
summary :
    { canonicalUrlOverride : Elm.Expression
    , siteName : Elm.Expression
    , image : Elm.Expression
    , description : Elm.Expression
    , title : Elm.Expression
    , locale : Elm.Expression
    }
    -> Elm.Expression
summary arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "summary"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
        )
        [ Elm.record
            [ Elm.field "canonicalUrlOverride" arg1.canonicalUrlOverride
            , Elm.field "siteName" arg1.siteName
            , Elm.field "image" arg1.image
            , Elm.field "description" arg1.description
            , Elm.field "title" arg1.title
            , Elm.field "locale" arg1.locale
            ]
        ]


{-| Will be displayed as a large card in twitter
See: <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/summary-card-with-large-image>

The options will also be used to build up the appropriate OpenGraph `<meta>` tags.

Note: You cannot include audio or video tags with summaries.
If you want one of those, use `audioPlayer` or `videoPlayer`

-}
summaryLarge :
    { canonicalUrlOverride : Elm.Expression
    , siteName : Elm.Expression
    , image : Elm.Expression
    , description : Elm.Expression
    , title : Elm.Expression
    , locale : Elm.Expression
    }
    -> Elm.Expression
summaryLarge arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "summaryLarge"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
        )
        [ Elm.record
            [ Elm.field "canonicalUrlOverride" arg1.canonicalUrlOverride
            , Elm.field "siteName" arg1.siteName
            , Elm.field "image" arg1.image
            , Elm.field "description" arg1.description
            , Elm.field "title" arg1.title
            , Elm.field "locale" arg1.locale
            ]
        ]


{-| Will be displayed as a Player card in twitter
See: <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/player-card>

OpenGraph video will also be included.
The options will also be used to build up the appropriate OpenGraph `<meta>` tags.

-}
videoPlayer :
    { canonicalUrlOverride : Elm.Expression
    , siteName : Elm.Expression
    , image : Elm.Expression
    , description : Elm.Expression
    , title : Elm.Expression
    , video : Elm.Expression
    , locale : Elm.Expression
    }
    -> Elm.Expression
videoPlayer arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "videoPlayer"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "video", Type.namedWith [ "Head", "Seo" ] "Video" [] )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
        )
        [ Elm.record
            [ Elm.field "canonicalUrlOverride" arg1.canonicalUrlOverride
            , Elm.field "siteName" arg1.siteName
            , Elm.field "image" arg1.image
            , Elm.field "description" arg1.description
            , Elm.field "title" arg1.title
            , Elm.field "video" arg1.video
            , Elm.field "locale" arg1.locale
            ]
        ]


{-| <https://ogp.me/#type_website>
-}
website : Elm.Expression -> Elm.Expression
website arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "website"
            (Type.function
                [ Type.namedWith [ "Head", "Seo" ] "Common" [] ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { article : Elm.Expression
    , audioPlayer : Elm.Expression
    , book : Elm.Expression
    , profile : Elm.Expression
    , song : Elm.Expression
    , summary : Elm.Expression
    , summaryLarge : Elm.Expression
    , videoPlayer : Elm.Expression
    , website : Elm.Expression
    }
id_ =
    { article =
        Elm.valueWith
            moduleName_
            "article"
            (Type.function
                [ Type.record
                    [ ( "tags", Type.list Type.string )
                    , ( "section", Type.maybe Type.string )
                    , ( "publishedTime"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    , ( "modifiedTime"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    , ( "expirationTime"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    ]
                , Type.namedWith [ "Head", "Seo" ] "Common" []
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
    , audioPlayer =
        Elm.valueWith
            moduleName_
            "audioPlayer"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "audio", Type.namedWith [ "Head", "Seo" ] "Audio" [] )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
    , book =
        Elm.valueWith
            moduleName_
            "book"
            (Type.function
                [ Type.namedWith [ "Head", "Seo" ] "Common" []
                , Type.record
                    [ ( "tags", Type.list Type.string )
                    , ( "isbn", Type.maybe Type.string )
                    , ( "releaseDate"
                      , Type.maybe
                            (Type.namedWith
                                [ "Head", "Seo" ]
                                "Iso8601DateTime"
                                []
                            )
                      )
                    ]
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
    , profile =
        Elm.valueWith
            moduleName_
            "profile"
            (Type.function
                [ Type.record
                    [ ( "firstName", Type.string )
                    , ( "lastName", Type.string )
                    , ( "username", Type.maybe Type.string )
                    ]
                , Type.namedWith [ "Head", "Seo" ] "Common" []
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
    , song =
        Elm.valueWith
            moduleName_
            "song"
            (Type.function
                [ Type.namedWith [ "Head", "Seo" ] "Common" []
                , Type.record
                    [ ( "duration", Type.maybe Type.int )
                    , ( "album", Type.maybe Type.int )
                    , ( "disc", Type.maybe Type.int )
                    , ( "track", Type.maybe Type.int )
                    ]
                ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
    , summary =
        Elm.valueWith
            moduleName_
            "summary"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
    , summaryLarge =
        Elm.valueWith
            moduleName_
            "summaryLarge"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
    , videoPlayer =
        Elm.valueWith
            moduleName_
            "videoPlayer"
            (Type.function
                [ Type.record
                    [ ( "canonicalUrlOverride", Type.maybe Type.string )
                    , ( "siteName", Type.string )
                    , ( "image", Type.namedWith [ "Head", "Seo" ] "Image" [] )
                    , ( "description", Type.string )
                    , ( "title", Type.string )
                    , ( "video", Type.namedWith [ "Head", "Seo" ] "Video" [] )
                    , ( "locale"
                      , Type.maybe
                            (Type.namedWith [ "Head", "Seo" ] "Locale" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Head", "Seo" ] "Common" [])
            )
    , website =
        Elm.valueWith
            moduleName_
            "website"
            (Type.function
                [ Type.namedWith [ "Head", "Seo" ] "Common" [] ]
                (Type.list (Type.namedWith [ "Head" ] "Tag" []))
            )
    }


