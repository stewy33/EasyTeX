module Renderer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Extra exposing (innerHtml)
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

            x :: xs ->
                makeBlock x
                    :: buildBlocks (not isMath) xs


parse : String -> List ContentBlock
parse str =
    buildBlocks False <| String.split "$" str


convertToHtml : ContentBlock -> Html a
convertToHtml cBlock =
    case cBlock of
        TextBlock str ->
            Markdown.toHtml [] str

        MathBlock str ->
            Katex.render str


render : String -> Html Msg
render str =
    let
        innerHtmlDecoder =
            Json.Decode.at [ "target", "innerHTML" ] Json.Decode.string
    in
        div
            [ class "editor"
            , contenteditable True
            , on "input" (Json.Decode.map FieldValue innerHtmlDecoder)
            ]
        <|
            List.map convertToHtml (parse str)
