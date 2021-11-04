module Elm.Gen.Pages.Internal.Platform.Cli exposing (cliApplication, id_, init, make_, moduleName_, requestDecoder, types_, update)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Pages", "Internal", "Platform", "Cli" ]


types_ :
    { program : Type.Annotation -> Type.Annotation
    , msg : Type.Annotation
    , model : Type.Annotation -> Type.Annotation
    , flags : Type.Annotation
    }
types_ =
    { program = \arg0 -> Type.namedWith moduleName_ "Program" [ arg0 ]
    , msg = Type.named moduleName_ "Msg"
    , model = \arg0 -> Type.namedWith moduleName_ "Model" [ arg0 ]
    , flags = Type.named moduleName_ "Flags"
    }


make_ :
    { msg :
        { gotDataBatch : Elm.Expression -> Elm.Expression
        , gotBuildError : Elm.Expression -> Elm.Expression
        , continue : Elm.Expression
        }
    }
make_ =
    { msg =
        { gotDataBatch =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "GotDataBatch"
                        (Type.namedWith [] "Msg" [])
                    )
                    [ ar0 ]
        , gotBuildError =
            \ar0 ->
                Elm.apply
                    (Elm.valueWith
                        moduleName_
                        "GotBuildError"
                        (Type.namedWith [] "Msg" [])
                    )
                    [ ar0 ]
        , continue =
            Elm.valueWith moduleName_ "Continue" (Type.namedWith [] "Msg" [])
        }
    }


{-| -}
cliApplication : Elm.Expression -> Elm.Expression
cliApplication arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "cliApplication"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.maybe (Type.var "route")
                    , Type.var "siteData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                ]
                (Type.namedWith
                    [ "Pages", "Internal", "Platform", "Cli" ]
                    "Program"
                    [ Type.maybe (Type.var "route") ]
                )
            )
        )
        [ arg1 ]


{-| -}
init :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
init arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "init"
            (Type.function
                [ Type.namedWith
                    [ "RenderRequest" ]
                    "RenderRequest"
                    [ Type.var "route" ]
                , Type.namedWith [ "Pages", "ContentCache" ] "ContentCache" []
                , Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.var "route"
                    , Type.var "siteData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                , Type.namedWith [ "Json", "Decode" ] "Value" []
                ]
                (Type.tuple
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Cli" ]
                        "Model"
                        [ Type.var "route" ]
                    )
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Effect" ]
                        "Effect"
                        []
                    )
                )
            )
        )
        [ arg1, arg2, arg3, arg4 ]


{-| -}
requestDecoder : Elm.Expression
requestDecoder =
    Elm.valueWith
        moduleName_
        "requestDecoder"
        (Type.namedWith
            [ "Json", "Decode" ]
            "Decoder"
            [ Type.record
                [ ( "masked"
                  , Type.namedWith
                        [ "Pages", "StaticHttp", "Request" ]
                        "Request"
                        []
                  )
                , ( "unmasked"
                  , Type.namedWith
                        [ "Pages", "StaticHttp", "Request" ]
                        "Request"
                        []
                  )
                ]
            ]
        )


{-| -}
update :
    Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
update arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "update"
            (Type.function
                [ Type.namedWith [ "Pages", "ContentCache" ] "ContentCache" []
                , Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.var "route"
                    , Type.var "siteData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                , Type.namedWith
                    [ "Pages", "Internal", "Platform", "Cli" ]
                    "Msg"
                    []
                , Type.namedWith
                    [ "Pages", "Internal", "Platform", "Cli" ]
                    "Model"
                    [ Type.var "route" ]
                ]
                (Type.tuple
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Cli" ]
                        "Model"
                        [ Type.var "route" ]
                    )
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Effect" ]
                        "Effect"
                        []
                    )
                )
            )
        )
        [ arg1, arg2, arg3, arg4 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { cliApplication : Elm.Expression
    , init : Elm.Expression
    , requestDecoder : Elm.Expression
    , update : Elm.Expression
    }
id_ =
    { cliApplication =
        Elm.valueWith
            moduleName_
            "cliApplication"
            (Type.function
                [ Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.maybe (Type.var "route")
                    , Type.var "siteData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                ]
                (Type.namedWith
                    [ "Pages", "Internal", "Platform", "Cli" ]
                    "Program"
                    [ Type.maybe (Type.var "route") ]
                )
            )
    , init =
        Elm.valueWith
            moduleName_
            "init"
            (Type.function
                [ Type.namedWith
                    [ "RenderRequest" ]
                    "RenderRequest"
                    [ Type.var "route" ]
                , Type.namedWith [ "Pages", "ContentCache" ] "ContentCache" []
                , Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.var "route"
                    , Type.var "siteData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                , Type.namedWith [ "Json", "Decode" ] "Value" []
                ]
                (Type.tuple
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Cli" ]
                        "Model"
                        [ Type.var "route" ]
                    )
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Effect" ]
                        "Effect"
                        []
                    )
                )
            )
    , requestDecoder =
        Elm.valueWith
            moduleName_
            "requestDecoder"
            (Type.namedWith
                [ "Json", "Decode" ]
                "Decoder"
                [ Type.record
                    [ ( "masked"
                      , Type.namedWith
                            [ "Pages", "StaticHttp", "Request" ]
                            "Request"
                            []
                      )
                    , ( "unmasked"
                      , Type.namedWith
                            [ "Pages", "StaticHttp", "Request" ]
                            "Request"
                            []
                      )
                    ]
                ]
            )
    , update =
        Elm.valueWith
            moduleName_
            "update"
            (Type.function
                [ Type.namedWith [ "Pages", "ContentCache" ] "ContentCache" []
                , Type.namedWith
                    [ "Pages", "ProgramConfig" ]
                    "ProgramConfig"
                    [ Type.var "userMsg"
                    , Type.var "userModel"
                    , Type.var "route"
                    , Type.var "siteData"
                    , Type.var "pageData"
                    , Type.var "sharedData"
                    ]
                , Type.namedWith
                    [ "Pages", "Internal", "Platform", "Cli" ]
                    "Msg"
                    []
                , Type.namedWith
                    [ "Pages", "Internal", "Platform", "Cli" ]
                    "Model"
                    [ Type.var "route" ]
                ]
                (Type.tuple
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Cli" ]
                        "Model"
                        [ Type.var "route" ]
                    )
                    (Type.namedWith
                        [ "Pages", "Internal", "Platform", "Effect" ]
                        "Effect"
                        []
                    )
                )
            )
    }


