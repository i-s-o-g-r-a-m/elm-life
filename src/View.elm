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
                [ greenDisc, yellowCross ]

            Dead ->
                [ yellowCross ]

            Reborn ->
                [ greenDisc, yellowCross, purpleDiamonds ]
        )


greenDisc =
    disc green


yellowCross =
    cross yellow


purpleDiamonds =
    diamonds purple
