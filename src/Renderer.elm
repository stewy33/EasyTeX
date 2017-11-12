module Renderer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Json.Decode
import KaTeX as Katex
import Debug


type Msg
    = FieldValue String


type ContentBlock
    = TextBlock String
    | MathBlock String


buildBlocks : Bool -> List String -> List ContentBlock
buildBlocks isMath blocks =
    let
        makeBlock str =
            if isMath then
                MathBlock str
            else
                TextBlock str
    in
        case blocks of
            [] ->
                []

            [ x ] ->
                [ TextBlock x ]

            x :: xs ->
                makeBlock x
                    :: buildBlocks (not isMath) xs


parse : String -> List ContentBlock
parse str =
    buildBlocks False <| String.split "$" str


convertToHtml : ContentBlock -> Html a
convertToHtml cBlock =
    let
        renderedStr =
            case cBlock of
                TextBlock str ->
                    str

                MathBlock str ->
                    Katex.renderToString str
    in
        Markdown.toHtml [ class "inline" ] renderedStr


render : String -> List (Html Msg)
render str =
    let
        onInput f =
            on "input" <|
                Json.Decode.map f <|
                    Json.Decode.at [ "target", "innerHTML" ] Json.Decode.string
    in
        [ div [ class "editorDisplay" ] <|
            List.map convertToHtml <|
                parse str
        , div
            [ class "editorOverlay"
            , contenteditable True
            , onInput FieldValue
            ]
            []
        ]
