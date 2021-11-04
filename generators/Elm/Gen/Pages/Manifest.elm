module Elm.Gen.Pages.Manifest exposing (id_, init, make_, moduleName_, toJson, types_, withBackgroundColor, withCategories, withDisplayMode, withIarcRatingId, withLang, withOrientation, withShortName, withThemeColor)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Manifest" ]


types_ :
    { iconPurpose : Type.Annotation
    , orientation : Type.Annotation
    , displayMode : Type.Annotation
    , icon : Type.Annotation
    , config : Type.Annotation
    }
types_ =
    { iconPurpose = Type.named moduleName_ "IconPurpose"
    , orientation = Type.named moduleName_ "Orientation"
    , displayMode = Type.named moduleName_ "DisplayMode"
    , icon = Type.named moduleName_ "Icon"
    , config = Type.named moduleName_ "Config"
    }


make_ :
    { iconPurpose :
        { iconPurposeMonochrome : Elm.Expression
        , iconPurposeMaskable : Elm.Expression
        , iconPurposeAny : Elm.Expression
        }
    , orientation :
        { any : Elm.Expression
        , natural : Elm.Expression
        , landscape : Elm.Expression
        , landscapePrimary : Elm.Expression
        , landscapeSecondary : Elm.Expression
        , portrait : Elm.Expression
        , portraitPrimary : Elm.Expression
        , portraitSecondary : Elm.Expression
        }
    , displayMode :
        { fullscreen : Elm.Expression
        , standalone : Elm.Expression
        , minimalUi : Elm.Expression
        , browser : Elm.Expression
        }
    }
make_ =
    { iconPurpose =
        { iconPurposeMonochrome =
            Elm.valueWith
                moduleName_
                "IconPurposeMonochrome"
                (Type.namedWith [] "IconPurpose" [])
        , iconPurposeMaskable =
            Elm.valueWith
                moduleName_
                "IconPurposeMaskable"
                (Type.namedWith [] "IconPurpose" [])
        , iconPurposeAny =
            Elm.valueWith
                moduleName_
                "IconPurposeAny"
                (Type.namedWith [] "IconPurpose" [])
        }
    , orientation =
        { any =
            Elm.valueWith moduleName_ "Any" (Type.namedWith [] "Orientation" [])
        , natural =
            Elm.valueWith
                moduleName_
                "Natural"
                (Type.namedWith [] "Orientation" [])
        , landscape =
            Elm.valueWith
                moduleName_
                "Landscape"
                (Type.namedWith [] "Orientation" [])
        , landscapePrimary =
            Elm.valueWith
                moduleName_
                "LandscapePrimary"
                (Type.namedWith [] "Orientation" [])
        , landscapeSecondary =
            Elm.valueWith
                moduleName_
                "LandscapeSecondary"
                (Type.namedWith [] "Orientation" [])
        , portrait =
            Elm.valueWith
                moduleName_
                "Portrait"
                (Type.namedWith [] "Orientation" [])
        , portraitPrimary =
            Elm.valueWith
                moduleName_
                "PortraitPrimary"
                (Type.namedWith [] "Orientation" [])
        , portraitSecondary =
            Elm.valueWith
                moduleName_
                "PortraitSecondary"
                (Type.namedWith [] "Orientation" [])
        }
    , displayMode =
        { fullscreen =
            Elm.valueWith
                moduleName_
                "Fullscreen"
                (Type.namedWith [] "DisplayMode" [])
        , standalone =
            Elm.valueWith
                moduleName_
                "Standalone"
                (Type.namedWith [] "DisplayMode" [])
        , minimalUi =
            Elm.valueWith
                moduleName_
                "MinimalUi"
                (Type.namedWith [] "DisplayMode" [])
        , browser =
            Elm.valueWith
                moduleName_
                "Browser"
                (Type.namedWith [] "DisplayMode" [])
        }
    }


{-| Setup a minimal Manifest.Config. You can then use the `with...` builder functions to set additional options.
-}
init :
    { description : Elm.Expression
    , name : Elm.Expression
    , startUrl : Elm.Expression
    , icons : Elm.Expression
    }
    -> Elm.Expression
init arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "init"
            (Type.function
                [ Type.record
                    [ ( "description", Type.string )
                    , ( "name", Type.string )
                    , ( "startUrl", Type.namedWith [ "Path" ] "Path" [] )
                    , ( "icons"
                      , Type.list
                            (Type.namedWith [ "Pages", "Manifest" ] "Icon" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ Elm.record
            [ Elm.field "description" arg1.description
            , Elm.field "name" arg1.name
            , Elm.field "startUrl" arg1.startUrl
            , Elm.field "icons" arg1.icons
            ]
        ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/background_color>.
-}
withBackgroundColor : Elm.Expression -> Elm.Expression -> Elm.Expression
withBackgroundColor arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withBackgroundColor"
            (Type.function
                [ Type.namedWith [ "Color" ] "Color" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ arg1, arg2 ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/categories>.
-}
withCategories : List Elm.Expression -> Elm.Expression -> Elm.Expression
withCategories arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withCategories"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Pages", "Manifest", "Category" ]
                        "Category"
                        []
                    )
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ Elm.list arg1, arg2 ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/display>.
-}
withDisplayMode : Elm.Expression -> Elm.Expression -> Elm.Expression
withDisplayMode arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withDisplayMode"
            (Type.function
                [ Type.namedWith [ "Pages", "Manifest" ] "DisplayMode" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ arg1, arg2 ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/iarc_rating_id>.
-}
withIarcRatingId : Elm.Expression -> Elm.Expression -> Elm.Expression
withIarcRatingId arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withIarcRatingId"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ arg1, arg2 ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/lang>.
-}
withLang : Elm.Expression -> Elm.Expression -> Elm.Expression
withLang arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withLang"
            (Type.function
                [ Type.namedWith [ "LanguageTag" ] "LanguageTag" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ arg1, arg2 ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/orientation>.
-}
withOrientation : Elm.Expression -> Elm.Expression -> Elm.Expression
withOrientation arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withOrientation"
            (Type.function
                [ Type.namedWith [ "Pages", "Manifest" ] "Orientation" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ arg1, arg2 ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/short_name>.
-}
withShortName : Elm.Expression -> Elm.Expression -> Elm.Expression
withShortName arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withShortName"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ arg1, arg2 ]


{-| Set <https://developer.mozilla.org/en-US/docs/Web/Manifest/theme_color>.
-}
withThemeColor : Elm.Expression -> Elm.Expression -> Elm.Expression
withThemeColor arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "withThemeColor"
            (Type.function
                [ Type.namedWith [ "Color" ] "Color" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
        )
        [ arg1, arg2 ]


{-| Feel free to use this, but in 99% of cases you won't need it. The generated
code will run this for you to generate your `manifest.json` file automatically!
-}
toJson : Elm.Expression -> Elm.Expression -> Elm.Expression
toJson arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toJson"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
        )
        [ arg1, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { init : Elm.Expression
    , withBackgroundColor : Elm.Expression
    , withCategories : Elm.Expression
    , withDisplayMode : Elm.Expression
    , withIarcRatingId : Elm.Expression
    , withLang : Elm.Expression
    , withOrientation : Elm.Expression
    , withShortName : Elm.Expression
    , withThemeColor : Elm.Expression
    , toJson : Elm.Expression
    }
id_ =
    { init =
        Elm.valueWith
            moduleName_
            "init"
            (Type.function
                [ Type.record
                    [ ( "description", Type.string )
                    , ( "name", Type.string )
                    , ( "startUrl", Type.namedWith [ "Path" ] "Path" [] )
                    , ( "icons"
                      , Type.list
                            (Type.namedWith [ "Pages", "Manifest" ] "Icon" [])
                      )
                    ]
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withBackgroundColor =
        Elm.valueWith
            moduleName_
            "withBackgroundColor"
            (Type.function
                [ Type.namedWith [ "Color" ] "Color" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withCategories =
        Elm.valueWith
            moduleName_
            "withCategories"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Pages", "Manifest", "Category" ]
                        "Category"
                        []
                    )
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withDisplayMode =
        Elm.valueWith
            moduleName_
            "withDisplayMode"
            (Type.function
                [ Type.namedWith [ "Pages", "Manifest" ] "DisplayMode" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withIarcRatingId =
        Elm.valueWith
            moduleName_
            "withIarcRatingId"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withLang =
        Elm.valueWith
            moduleName_
            "withLang"
            (Type.function
                [ Type.namedWith [ "LanguageTag" ] "LanguageTag" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withOrientation =
        Elm.valueWith
            moduleName_
            "withOrientation"
            (Type.function
                [ Type.namedWith [ "Pages", "Manifest" ] "Orientation" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withShortName =
        Elm.valueWith
            moduleName_
            "withShortName"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , withThemeColor =
        Elm.valueWith
            moduleName_
            "withThemeColor"
            (Type.function
                [ Type.namedWith [ "Color" ] "Color" []
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Pages", "Manifest" ] "Config" [])
            )
    , toJson =
        Elm.valueWith
            moduleName_
            "toJson"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Pages", "Manifest" ] "Config" []
                ]
                (Type.namedWith [ "Json", "Encode" ] "Value" [])
            )
    }


