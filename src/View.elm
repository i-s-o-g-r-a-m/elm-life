module View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Shapes exposing (..)
import Svg exposing (svg)
import Svg.Attributes exposing (version, x, y, width, height)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ style [ ( "text-align", "center" ) ] ]
        (List.map (\row -> div [ style [ ( "margin-top", "-10px" ) ] ] (List.map renderCell row)) model.matrix)


renderCell cell =
    svg
        [ version "1.1"
        , x "0"
        , y "0"
        , width "60"
        , height "70"
        ]
        (case (cell) of
            Live ->
                [ disc magenta, cross yellow ]

            Dead ->
                [ cross yellow ]

            Reborn ->
                [ disc magenta, cross yellow, diamonds cyan ]
        )
