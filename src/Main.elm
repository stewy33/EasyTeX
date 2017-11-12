port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Renderer exposing (..)
import Html exposing (Html, Attribute, div, fieldset, input, label, text)
import Html.Attributes exposing (name, style, type_)
import Html.Events exposing (onClick)
import Markdown

type alias Model =
    { fontSize : String
    , body : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )

type Msg
  = FieldValue String | FontSize String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        isMath x =
            case x of
                MathBlock str ->
                    Just str

                TextBlock str ->
                    Nothing
    in
        case msg of
            FieldValue str ->
                ( { body = str }, Cmd.none )
            FontSize newFontSize ->
                { model | fontSize = newFontSize }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "page" ] [ div [ class "container", style [("font-size", model.fontSize)] ] <| render model.body ]
    div [class "changefont"]
    [ fontSelect ]

fontSelect : Html msg
fontSelect =
  let onChange f = on "change" <| Json.Decode.map f <| Json.Decode.at ["target", "value"] Json.Decode.String
  select
    [ style [("padding", "20px")]
    ]
    [onChange FontSize]
    [ viewOption "0.8em",
      viewOption "1em" ,
      viewOption "1.2em" ,
    ]


sizeToStyle : FontSize -> Attribute msg
sizeToStyle fontSize =
  let
    size =
      case fontSize of
        Small ->
          "0.8em"

        Medium ->
          "1em"

        Large ->
          "1.2em"
  in
    style [("font-size", size)]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
