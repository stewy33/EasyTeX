module Renderer exposing (..)

import Html exposing (..)
import KaTeX as Katex
import Debug


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
    String.split "$" str
        |> buildBlocks False


render : String -> Html a
render str =
    Debug.log (toString (parse str)) (text "hi")
