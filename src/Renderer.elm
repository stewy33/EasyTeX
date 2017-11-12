module Renderer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import List
import Json.Decode
import KaTeX as Katex


type Msg
    = FieldValue String


type alias ID =
    Int


type ContentBlock
    = TextBlock String
    | MathBlock ID String


buildBlocks : Int -> List String -> List ContentBlock
buildBlocks id blocks =
    let
        makeBlock str =
            if id % 2 == 0 then
                TextBlock str
            else
                MathBlock id str
    in
        case blocks of
            [] ->
                []

            [ x ] ->
                [ TextBlock x ]

            x :: xs ->
                makeBlock x
                    :: buildBlocks (id + 1) xs


parse : String -> List ContentBlock
parse str =
    buildBlocks 0 <| String.split "$" str


convertToHtml : ContentBlock -> Html a
convertToHtml cBlock =
    case cBlock of
        TextBlock str ->
            Markdown.toHtml [ class "inline" ] str

        MathBlock iD str ->
            div [ id <| toString iD, class "math-wrapper" ] [ Katex.render str ]


normalizeSpaces : List ContentBlock -> List (Html a) -> String
normalizeSpaces cBlocks htmls =
    let
        combine cBlock html =
            case cBlock of
                MathBlock id str ->
                    str

                TextBlock str ->
                    str
    in
        String.concat <| List.map2 combine cBlocks htmls


render : String -> List (Html Msg)
render str =
    let
        onInput f =
            on "input" <|
                Json.Decode.map f <|
                    Json.Decode.at [ "target", "innerHTML" ] Json.Decode.string

        editorDisplay =
            (List.map convertToHtml <| parse str) ++ [ div [ class "cursor" ] [] ]
    in
        [ div [ class "editorDisplay" ] editorDisplay
        , div
            [ class "editorOverlay"
            , contenteditable True
            , onInput FieldValue
            ]
            [ Markdown.toHtml [ class "inline" ]
                (normalizeSpaces (parse str) editorDisplay)
            ]
        ]
