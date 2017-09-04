module View exposing (view, cellWidth, cellHeight)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Shapes exposing (..)
import Svg exposing (svg)
import Svg.Attributes exposing (version, x, y, width, height)
import Types exposing (..)


cellWidth =
    60


cellHeight =
    70


view : Model -> Html Msg
view model =
    div
        [ style [ ( "text-align", "center" ), ( "margin-top", "20px" ) ] ]
        (List.map
            (\row -> div [ style [ ( "margin-top", "-10px" ) ] ] (List.map renderCell row))
            model.matrix
        )


renderCell cell =
    svg
        [ version "1.1"
        , x "0"
        , y "0"
        , width (toString cellWidth)
        , height (toString cellHeight)
        ]
        (case (cell) of
            Live ->
                [ blueDisc, redCross ]

            Dead ->
                [ redCross ]

            Reborn ->
                [ blueDisc, redCross, greenDiamonds ]
        )


blueDisc =
    disc blue


redCross =
    cross red


greenDiamonds =
    diamonds green
