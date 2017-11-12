import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Events.Extra exposing (..)
import String
import StartApp.Simple as StartApp

view =
  div [ class "fetchele" ] [
    {-input [ class "search-box" ] [ ],
    ul [ class "collection" ] [
        li [ class "collection-item active" ] [ text "#Elm" ],
        li [ class "collection-item" ] [ text "#react.js" ],
        li [ class "collection-item" ] [ text "#ember" ]
    ] -}
  ]

main =
    view

    -- MODEL
    type alias ContentBlock =
      { TextBlock: String
      , MathBlock: String
      }

    initialModel : ContentBlock
    initialModel =
      { TextBlock = getelementbyid [""]
      , MathBlock = word[""]
      }
