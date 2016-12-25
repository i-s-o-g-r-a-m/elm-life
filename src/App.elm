module Main exposing (..)

import Html exposing (Html)
import State exposing (init, update, subscriptions)
import Types exposing (..)
import View exposing (view)


main : Program Never Types.Model Types.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
