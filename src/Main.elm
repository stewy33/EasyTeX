module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Renderer exposing (Msg(..), render)


type alias Model =
    { body : String }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


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
    div [ class "page" ] [ render model.body ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
