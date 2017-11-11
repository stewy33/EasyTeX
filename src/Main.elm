module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Debug


type alias Model =
    { body : String }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


type Msg
    = FieldValue String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldValue str ->
            Debug.log str
                ( { model | body = str }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    let
        innerHtmlDecoder =
            Json.Decode.at [ "target", "innerHTML" ] Json.Decode.string
    in
        div []
            [ div
                [ contenteditable True
                , on "input" (Json.Decode.map FieldValue innerHtmlDecoder)
                ]
                []
            , div [] [ text model.body ]
            ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
