module Types exposing (..)

import Time exposing (Time)


type alias Model =
    { matrix : List (List Cell) }


type Msg
    = Tick Time
    | SeedMatrix Float


type Cell
    = Live
    | Dead
    | Resurrected
