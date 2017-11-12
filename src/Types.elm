module Types exposing (..)


type Msg
    = FieldValue String
    | NewFontSize String


type alias Model =
    { body : String
    , fontSize : String
    }


type alias ID =
    Int


type ContentBlock
    = TextBlock String
    | MathBlock ID String
