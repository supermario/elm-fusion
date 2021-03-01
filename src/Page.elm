module Page exposing (..)

import Browser exposing (..)
import Browser.Dom
import Browser.Navigation as Nav exposing (Key)
import Dict
import Task
import Types exposing (..)
import Url exposing (Url)
import Url.Parser exposing (..)
import Url.Parser.Query as Query


homepage =
    FusionHttp


pageToPath : Page -> String
pageToPath page =
    case page of
        FusionHttp ->
            "/fusion"


pathToPage : Url -> Page
pathToPage url =
    let
        match =
            [ map FusionHttp (s "fusion")
            ]
                |> oneOf
                |> (\parser -> parse parser url)
                |> Maybe.withDefault homepage
    in
    match


title page =
    pageName page


pageName page =
    case page of
        FusionHttp ->
            "Fuse"


urlClicked model urlRequest =
    case urlRequest of
        Internal url ->
            ( model
            , Cmd.batch [ Nav.pushUrl model.key (Url.toString url), scrollPageToTop ]
            )

        External url ->
            ( model
            , Nav.load url
            )


urlChanged model url onPageInit =
    let
        page =
            pathToPage url
    in
    if model.page /= page then
        ( { model | page = page }
        , Cmd.batch
            [ onPageInit model page
            , scrollPageToTop
            ]
        )

    else
        ( model, Cmd.none )


scrollPageToTop =
    Task.perform (\_ -> NoOpFrontendMsg) (Browser.Dom.setViewport 0 0)
