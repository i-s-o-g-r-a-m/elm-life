module View exposing (view)

import Html exposing (Html, div, text)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div [] (List.map (\row -> div [] (List.map renderCell row)) model.matrix)


renderCell cell =
    case cell of
        Live ->
            text "o"

        Dead ->
            text "-"

        Resurrected ->
            text "o"
