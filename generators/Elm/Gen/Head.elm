module Elm.Gen.Head exposing (appleTouchIcon, canonicalLink, currentPageFullUrl, icon, id_, make_, metaName, metaProperty, moduleName_, raw, rootLanguage, rssLink, sitemapLink, structuredData, toJson, types_, urlAttribute)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Head" ]


types_ : { attributeValue : Type.Annotation, tag : Type.Annotation }
types_ =
    { attributeValue = Type.named moduleName_ "AttributeValue"
    , tag = Type.named moduleName_ "Tag"
    }


make_ : {}
make_ =
    {}


{-| Example:

    metaName
        [ ( "name", "twitter:card" )
        , ( "content", "summary_large_image" )
        ]

Results in `<meta name="twitter:card" content="summary_large_image" />`

-}
metaName : Elm.Expression -> Elm.Expression -> Elm.Expression
metaName arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "metaName"
            (Type.function
                [ Type.string, Type.namedWith [ "Head" ] "AttributeValue" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
        )
        [ arg1, arg2 ]


{-| Example:

    Head.metaProperty "fb:app_id" (Head.raw "123456789")

Results in `<meta property="fb:app_id" content="123456789" />`

-}
metaProperty : Elm.Expression -> Elm.Expression -> Elm.Expression
metaProperty arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "metaProperty"
            (Type.function
                [ Type.string, Type.namedWith [ "Head" ] "AttributeValue" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
        )
        [ arg1, arg2 ]


{-| Add a link to the site's RSS feed.

Example:

    rssLink "/feed.xml"

```html
<link rel="alternate" type="application/rss+xml" href="/rss.xml">
```

-}
rssLink : Elm.Expression -> Elm.Expression
rssLink arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "rssLink"
            (Type.function [ Type.string ] (Type.namedWith [ "Head" ] "Tag" []))
        )
        [ arg1 ]


{-| Add a link to the site's RSS feed.

Example:

    sitemapLink "/feed.xml"

```html
<link rel="sitemap" type="application/xml" href="/sitemap.xml">
```

-}
sitemapLink : Elm.Expression -> Elm.Expression
sitemapLink arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sitemapLink"
            (Type.function [ Type.string ] (Type.namedWith [ "Head" ] "Tag" []))
        )
        [ arg1 ]


{-| Set the language for a page.

<https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang>

    import Head
    import LanguageTag
    import LanguageTag.Language

    LanguageTag.Language.de -- sets the page's language to German
        |> LanguageTag.build LanguageTag.emptySubtags
        |> Head.rootLanguage

This results pre-rendered HTML with a global lang tag set.

```html
<html lang="no">
...
</html>
```

-}
rootLanguage : Elm.Expression -> Elm.Expression
rootLanguage arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "rootLanguage"
            (Type.function
                [ Type.namedWith [ "LanguageTag" ] "LanguageTag" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
        )
        [ arg1 ]


{-| You can learn more about structured data in [Google's intro to structured data](https://developers.google.com/search/docs/guides/intro-structured-data).

When you add a `structuredData` item to one of your pages in `elm-pages`, it will add `json-ld` data to your document that looks like this:

```html
<script type="application/ld+json">
{
   "@context":"http://schema.org/",
   "@type":"Article",
   "headline":"Extensible Markdown Parsing in Pure Elm",
   "description":"Introducing a new parser that extends your palette with no additional syntax",
   "image":"https://elm-pages.com/images/article-covers/extensible-markdown-parsing.jpg",
   "author":{
      "@type":"Person",
      "name":"Dillon Kearns"
   },
   "publisher":{
      "@type":"Person",
      "name":"Dillon Kearns"
   },
   "url":"https://elm-pages.com/blog/extensible-markdown-parsing-in-elm",
   "datePublished":"2019-10-08",
   "mainEntityOfPage":{
      "@type":"SoftwareSourceCode",
      "codeRepository":"https://github.com/dillonkearns/elm-pages",
      "description":"A statically typed site generator for Elm.",
      "author":"Dillon Kearns",
      "programmingLanguage":{
         "@type":"ComputerLanguage",
         "url":"http://elm-lang.org/",
         "name":"Elm",
         "image":"http://elm-lang.org/",
         "identifier":"http://elm-lang.org/"
      }
   }
}
</script>
```

To get that data, you would write this in your `elm-pages` head tags:

    import Json.Encode as Encode

    {-| <https://schema.org/Article>
    -}
    encodeArticle :
        { title : String
        , description : String
        , author : StructuredDataHelper { authorMemberOf | personOrOrganization : () } authorPossibleFields
        , publisher : StructuredDataHelper { publisherMemberOf | personOrOrganization : () } publisherPossibleFields
        , url : String
        , imageUrl : String
        , datePublished : String
        , mainEntityOfPage : Encode.Value
        }
        -> Head.Tag
    encodeArticle info =
        Encode.object
            [ ( "@context", Encode.string "http://schema.org/" )
            , ( "@type", Encode.string "Article" )
            , ( "headline", Encode.string info.title )
            , ( "description", Encode.string info.description )
            , ( "image", Encode.string info.imageUrl )
            , ( "author", encode info.author )
            , ( "publisher", encode info.publisher )
            , ( "url", Encode.string info.url )
            , ( "datePublished", Encode.string info.datePublished )
            , ( "mainEntityOfPage", info.mainEntityOfPage )
            ]
            |> Head.structuredData

Take a look at this [Google Search Gallery](https://developers.google.com/search/docs/guides/search-gallery)
to see some examples of how structured data can be used by search engines to give rich search results. It can help boost
your rankings, get better engagement for your content, and also make your content more accessible. For example,
voice assistant devices can make use of structured data. If you're hosting a conference and want to make the event
date and location easy for attendees to find, this can make that information more accessible.

For the current version of API, you'll need to make sure that the format is correct and contains the required and recommended
structure.

Check out <https://schema.org> for a comprehensive listing of possible data types and fields. And take a look at
Google's [Structured Data Testing Tool](https://search.google.com/structured-data/testing-tool)
too make sure that your structured data is valid and includes the recommended values.

In the future, `elm-pages` will likely support a typed API, but schema.org is a massive spec, and changes frequently.
And there are multiple sources of information on the possible and recommended structure. So it will take some time
for the right API design to evolve. In the meantime, this allows you to make use of this for SEO purposes.

-}
structuredData : Elm.Expression -> Elm.Expression
structuredData arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "structuredData"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
        )
        [ arg1 ]


{-| Create an `AttributeValue` representing the current page's full url.
-}
currentPageFullUrl : Elm.Expression
currentPageFullUrl =
    Elm.valueWith
        moduleName_
        "currentPageFullUrl"
        (Type.namedWith [ "Head" ] "AttributeValue" [])


{-| Create an `AttributeValue` from an `ImagePath`.
-}
urlAttribute : Elm.Expression -> Elm.Expression
urlAttribute arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "urlAttribute"
            (Type.function
                [ Type.namedWith [ "Pages", "Url" ] "Url" [] ]
                (Type.namedWith [ "Head" ] "AttributeValue" [])
            )
        )
        [ arg1 ]


{-| Create a raw `AttributeValue` (as opposed to some kind of absolute URL).
-}
raw : Elm.Expression -> Elm.Expression
raw arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "raw"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "Head" ] "AttributeValue" [])
            )
        )
        [ arg1 ]


{-| Note: the type must be png.
See <https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html>.

If a size is provided, it will be turned into square dimensions as per the recommendations here: <https://developers.google.com/web/fundamentals/design-and-ux/browser-customization/#safari>

Images must be png's, and non-transparent images are recommended. Current recommended dimensions are 180px and 192px.

-}
appleTouchIcon : Elm.Expression -> Elm.Expression -> Elm.Expression
appleTouchIcon arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "appleTouchIcon"
            (Type.function
                [ Type.maybe Type.int
                , Type.namedWith [ "Pages", "Url" ] "Url" []
                ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
        )
        [ arg1, arg2 ]


{-| -}
icon : List Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
icon arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "icon"
            (Type.function
                [ Type.list (Type.tuple Type.int Type.int)
                , Type.namedWith [ "MimeType" ] "MimeImage" []
                , Type.namedWith [ "Pages", "Url" ] "Url" []
                ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
        )
        [ Elm.list arg1, arg2, arg3 ]


{-| Feel free to use this, but in 99% of cases you won't need it. The generated
code will run this for you to generate your `manifest.json` file automatically!
-}
toJson : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
toJson arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toJson"
            (Type.function
                [ Type.string, Type.string, Type.namedWith [ "Head" ] "Tag" [] ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
        )
        [ arg1, arg2, arg3 ]


{-| It's recommended that you use the `Seo` module helpers, which will provide this
for you, rather than directly using this.

Example:

    Head.canonicalLink "https://elm-pages.com"

-}
canonicalLink : Elm.Expression -> Elm.Expression
canonicalLink arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "canonicalLink"
            (Type.function
                [ Type.maybe Type.string ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { metaName : Elm.Expression
    , metaProperty : Elm.Expression
    , rssLink : Elm.Expression
    , sitemapLink : Elm.Expression
    , rootLanguage : Elm.Expression
    , structuredData : Elm.Expression
    , currentPageFullUrl : Elm.Expression
    , urlAttribute : Elm.Expression
    , raw : Elm.Expression
    , appleTouchIcon : Elm.Expression
    , icon : Elm.Expression
    , toJson : Elm.Expression
    , canonicalLink : Elm.Expression
    }
id_ =
    { metaName =
        Elm.valueWith
            moduleName_
            "metaName"
            (Type.function
                [ Type.string, Type.namedWith [ "Head" ] "AttributeValue" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
    , metaProperty =
        Elm.valueWith
            moduleName_
            "metaProperty"
            (Type.function
                [ Type.string, Type.namedWith [ "Head" ] "AttributeValue" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
    , rssLink =
        Elm.valueWith
            moduleName_
            "rssLink"
            (Type.function [ Type.string ] (Type.namedWith [ "Head" ] "Tag" []))
    , sitemapLink =
        Elm.valueWith
            moduleName_
            "sitemapLink"
            (Type.function [ Type.string ] (Type.namedWith [ "Head" ] "Tag" []))
    , rootLanguage =
        Elm.valueWith
            moduleName_
            "rootLanguage"
            (Type.function
                [ Type.namedWith [ "LanguageTag" ] "LanguageTag" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
    , structuredData =
        Elm.valueWith
            moduleName_
            "structuredData"
            (Type.function
                [ Type.namedWith [ "Json", "Encode" ] "Value" [] ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
    , currentPageFullUrl =
        Elm.valueWith
            moduleName_
            "currentPageFullUrl"
            (Type.namedWith [ "Head" ] "AttributeValue" [])
    , urlAttribute =
        Elm.valueWith
            moduleName_
            "urlAttribute"
            (Type.function
                [ Type.namedWith [ "Pages", "Url" ] "Url" [] ]
                (Type.namedWith [ "Head" ] "AttributeValue" [])
            )
    , raw =
        Elm.valueWith
            moduleName_
            "raw"
            (Type.function
                [ Type.string ]
                (Type.namedWith [ "Head" ] "AttributeValue" [])
            )
    , appleTouchIcon =
        Elm.valueWith
            moduleName_
            "appleTouchIcon"
            (Type.function
                [ Type.maybe Type.int
                , Type.namedWith [ "Pages", "Url" ] "Url" []
                ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
    , icon =
        Elm.valueWith
            moduleName_
            "icon"
            (Type.function
                [ Type.list (Type.tuple Type.int Type.int)
                , Type.namedWith [ "MimeType" ] "MimeImage" []
                , Type.namedWith [ "Pages", "Url" ] "Url" []
                ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
    , toJson =
        Elm.valueWith
            moduleName_
            "toJson"
            (Type.function
                [ Type.string, Type.string, Type.namedWith [ "Head" ] "Tag" [] ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
    , canonicalLink =
        Elm.valueWith
            moduleName_
            "canonicalLink"
            (Type.function
                [ Type.maybe Type.string ]
                (Type.namedWith [ "Head" ] "Tag" [])
            )
    }


