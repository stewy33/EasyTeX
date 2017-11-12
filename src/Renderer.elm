module Renderer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import List
import Types exposing (..)
import Json.Decode as Json
import KaTeX as Katex


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


concatMap : List ContentBlock -> String
concatMap cBlocks =
    let
        extract cBlock =
            case cBlock of
                MathBlock id str ->
                    str

                TextBlock str ->
                    str
    in
        String.concat <| List.map extract cBlocks


render : Model -> List (Html Msg)
render model =
    let
        onInput f =
            on "input" <|
                Json.map f <|
                    Json.at [ "target", "innerHTML" ] Json.string

        editorDisplay =
            (List.map convertToHtml <| parse model.body) ++ [ div [ class "cursor" ] [] ]
    in
        [ div [ style [ ( "font-size", model.fontSize ) ], class "editorDisplay" ] editorDisplay
        , div
            [ class "editorOverlay"
            , contenteditable True
            , onInput FieldValue
            ]
            [ Markdown.toHtml [ class "inline" ] <|
                concatMap <|
                    parse model.body
            ]
        ]
