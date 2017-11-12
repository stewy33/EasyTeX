port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Renderer exposing (..)


type alias Model =
    { body : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        isMath x =
            case x of
                MathBlock id str ->
                    Just str

                TextBlock str ->
                    Nothing
    in
        case msg of
            FieldValue str ->
                ( { body = str }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "page" ] [ div [ class "container" ] <| render model.body ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
