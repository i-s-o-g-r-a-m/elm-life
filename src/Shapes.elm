module Shapes exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


disc color =
    g
        []
        [ circle [ cx "28", cy "42", r "25", fill color, fillOpacity ".5" ] []
        , circle [ cx "28", cy "42", r "18", fill "#ffffff", fillOpacity "1" ] []
        ]


cross color =
    g
        []
        [ rect [ x "22", y "18", width "12", height "48", fill color, fillOpacity ".4" ] []
        , rect [ x "3", y "36", width "49", height "12", fill color, fillOpacity ".4" ] []
        ]


diamonds color =
    g
        []
        [ rect [ x "20", y "0", width "20", height "20", fill color, transform "rotate(45)", fillOpacity ".5" ] []
        , rect [ x "40", y "-20", width "20", height "20", fill color, transform "rotate(45)", fillOpacity ".5" ] []
        , rect [ x "40", y "20", width "20", height "20", fill color, transform "rotate(45)", fillOpacity ".5" ] []
        , rect [ x "60", y "0", width "20", height "20", fill color, transform "rotate(45)", fillOpacity ".5" ] []
        ]
