module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Json
import Html.Events exposing (..)
import Renderer exposing (..)
import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( Model "" "1.25em", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldValue str ->
            ( { model | body = str }, Cmd.none )

        NewFontSize size ->
            ( { model | fontSize = size }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


fontSelect : Html Msg
fontSelect =
    let
        onChange f =
            on "change" <| Json.map f <| Json.at [ "target", "value" ] Json.string
    in
        select
            [ onChange NewFontSize ]
            [ option [ value "1.0em" ] [ text "Small ▼" ]
            , option [ value "1.25em", selected True ] [ text "Medium ▼" ]
            , option [ value "1.5em" ] [ text "Large ▼" ]
            ]


view : Model -> Html Msg
view model =
    body []
        [ header []
            [ h1 [] [ text "EasyTeX" ]
            , div [ class "toolbar" ] [ fontSelect ]
            ]
        , div [ class "page" ]
            [ div [ class "container" ] <|
                render model
            ]
        ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
