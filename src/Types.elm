module Types exposing (..)

import Time exposing (Time)


type alias Model =
    { matrix : List (List Int) }


type Msg
    = Tick Time
    | SeedMatrix Float
