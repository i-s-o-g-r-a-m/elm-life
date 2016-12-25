module View exposing (view)

import Html exposing (Html, div, text)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div [] (List.map (\row -> div [] (List.map renderCell row)) model.matrix)


renderCell cell =
    text
        (if cell == 0 then
            "-"
         else
            "o"
        )
