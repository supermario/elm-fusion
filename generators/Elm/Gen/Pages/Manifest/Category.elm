module Elm.Gen.Pages.Manifest.Category exposing (books, business, custom, education, entertainment, finance, fitness, food, games, government, health, id_, kids, lifestyle, magazines, make_, medical, moduleName_, music, navigation, news, personalization, photo, politics, productivity, security, shopping, social, sports, toString, travel, types_, utilities, weather)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Manifest", "Category" ]


types_ : { category : Type.Annotation }
types_ =
    { category = Type.named moduleName_ "Category" }


make_ : {}
make_ =
    {}


{-| Turn a category into its official String representation, as seen
here: <https://github.com/w3c/manifest/wiki/Categories>.
-}
toString : Elm.Expression -> Elm.Expression
toString arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toString"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Manifest", "Category" ]
                    "Category"
                    []
                ]
                Type.string
            )
        )
        [ arg1 ]


{-| Creates the described category.
-}
books : Elm.Expression
books =
    Elm.valueWith
        moduleName_
        "books"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
business : Elm.Expression
business =
    Elm.valueWith
        moduleName_
        "business"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
education : Elm.Expression
education =
    Elm.valueWith
        moduleName_
        "education"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
entertainment : Elm.Expression
entertainment =
    Elm.valueWith
        moduleName_
        "entertainment"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
finance : Elm.Expression
finance =
    Elm.valueWith
        moduleName_
        "finance"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
fitness : Elm.Expression
fitness =
    Elm.valueWith
        moduleName_
        "fitness"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
food : Elm.Expression
food =
    Elm.valueWith
        moduleName_
        "food"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
games : Elm.Expression
games =
    Elm.valueWith
        moduleName_
        "games"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
government : Elm.Expression
government =
    Elm.valueWith
        moduleName_
        "government"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
health : Elm.Expression
health =
    Elm.valueWith
        moduleName_
        "health"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
kids : Elm.Expression
kids =
    Elm.valueWith
        moduleName_
        "kids"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
lifestyle : Elm.Expression
lifestyle =
    Elm.valueWith
        moduleName_
        "lifestyle"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
magazines : Elm.Expression
magazines =
    Elm.valueWith
        moduleName_
        "magazines"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
medical : Elm.Expression
medical =
    Elm.valueWith
        moduleName_
        "medical"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
music : Elm.Expression
music =
    Elm.valueWith
        moduleName_
        "music"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
navigation : Elm.Expression
navigation =
    Elm.valueWith
        moduleName_
        "navigation"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
news : Elm.Expression
news =
    Elm.valueWith
        moduleName_
        "news"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
personalization : Elm.Expression
personalization =
    Elm.valueWith
        moduleName_
        "personalization"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
photo : Elm.Expression
photo =
    Elm.valueWith
        moduleName_
        "photo"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
politics : Elm.Expression
politics =
    Elm.valueWith
        moduleName_
        "politics"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
productivity : Elm.Expression
productivity =
    Elm.valueWith
        moduleName_
        "productivity"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
security : Elm.Expression
security =
    Elm.valueWith
        moduleName_
        "security"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
shopping : Elm.Expression
shopping =
    Elm.valueWith
        moduleName_
        "shopping"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
social : Elm.Expression
social =
    Elm.valueWith
        moduleName_
        "social"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
sports : Elm.Expression
sports =
    Elm.valueWith
        moduleName_
        "sports"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
travel : Elm.Expression
travel =
    Elm.valueWith
        moduleName_
        "travel"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
utilities : Elm.Expression
utilities =
    Elm.valueWith
        moduleName_
        "utilities"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| Creates the described category.
-}
weather : Elm.Expression
weather =
    Elm.valueWith
        moduleName_
        "weather"
        (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])


{-| It's best to use the pre-defined categories to ensure that clients (Android, iOS,
Chrome, Windows app store, etc.) are aware of it and can handle it appropriately.
But, if you're confident about using a custom one, you can do so with `Pages.Manifest.custom`.
-}
custom : Elm.Expression -> Elm.Expression
custom arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "custom"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "Pages", "Manifest", "Category" ]
                    "Category"
                    []
                )
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { toString : Elm.Expression
    , books : Elm.Expression
    , business : Elm.Expression
    , education : Elm.Expression
    , entertainment : Elm.Expression
    , finance : Elm.Expression
    , fitness : Elm.Expression
    , food : Elm.Expression
    , games : Elm.Expression
    , government : Elm.Expression
    , health : Elm.Expression
    , kids : Elm.Expression
    , lifestyle : Elm.Expression
    , magazines : Elm.Expression
    , medical : Elm.Expression
    , music : Elm.Expression
    , navigation : Elm.Expression
    , news : Elm.Expression
    , personalization : Elm.Expression
    , photo : Elm.Expression
    , politics : Elm.Expression
    , productivity : Elm.Expression
    , security : Elm.Expression
    , shopping : Elm.Expression
    , social : Elm.Expression
    , sports : Elm.Expression
    , travel : Elm.Expression
    , utilities : Elm.Expression
    , weather : Elm.Expression
    , custom : Elm.Expression
    }
id_ =
    { toString =
        Elm.valueWith
            moduleName_
            "toString"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "Manifest", "Category" ]
                    "Category"
                    []
                ]
                Type.string
            )
    , books =
        Elm.valueWith
            moduleName_
            "books"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , business =
        Elm.valueWith
            moduleName_
            "business"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , education =
        Elm.valueWith
            moduleName_
            "education"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , entertainment =
        Elm.valueWith
            moduleName_
            "entertainment"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , finance =
        Elm.valueWith
            moduleName_
            "finance"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , fitness =
        Elm.valueWith
            moduleName_
            "fitness"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , food =
        Elm.valueWith
            moduleName_
            "food"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , games =
        Elm.valueWith
            moduleName_
            "games"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , government =
        Elm.valueWith
            moduleName_
            "government"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , health =
        Elm.valueWith
            moduleName_
            "health"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , kids =
        Elm.valueWith
            moduleName_
            "kids"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , lifestyle =
        Elm.valueWith
            moduleName_
            "lifestyle"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , magazines =
        Elm.valueWith
            moduleName_
            "magazines"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , medical =
        Elm.valueWith
            moduleName_
            "medical"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , music =
        Elm.valueWith
            moduleName_
            "music"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , navigation =
        Elm.valueWith
            moduleName_
            "navigation"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , news =
        Elm.valueWith
            moduleName_
            "news"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , personalization =
        Elm.valueWith
            moduleName_
            "personalization"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , photo =
        Elm.valueWith
            moduleName_
            "photo"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , politics =
        Elm.valueWith
            moduleName_
            "politics"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , productivity =
        Elm.valueWith
            moduleName_
            "productivity"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , security =
        Elm.valueWith
            moduleName_
            "security"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , shopping =
        Elm.valueWith
            moduleName_
            "shopping"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , social =
        Elm.valueWith
            moduleName_
            "social"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , sports =
        Elm.valueWith
            moduleName_
            "sports"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , travel =
        Elm.valueWith
            moduleName_
            "travel"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , utilities =
        Elm.valueWith
            moduleName_
            "utilities"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , weather =
        Elm.valueWith
            moduleName_
            "weather"
            (Type.namedWith [ "Pages", "Manifest", "Category" ] "Category" [])
    , custom =
        Elm.valueWith
            moduleName_
            "custom"
            (Type.function
                [ Type.string ]
                (Type.namedWith
                    [ "Pages", "Manifest", "Category" ]
                    "Category"
                    []
                )
            )
    }


