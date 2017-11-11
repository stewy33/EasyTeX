module Renderer exposing (..)


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
                makeBlock x :: buildBlocks (not isMath) xs


render : String -> List ContentBlock
render str =
    String.split "$" str
        |> buildBlocks False
