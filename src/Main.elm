module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Html msg
main =
    div [ id "editor", contenteditable True ] [ text "Hello World!" ]
