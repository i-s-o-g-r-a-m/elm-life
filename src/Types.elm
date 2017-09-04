module Types exposing (..)

import Time exposing (Time)
import Window


type alias Model =
    { matrix : List (List Cell) }


type Msg
    = Tick Time
    | SeedMatrix ( Float, Window.Size )
    | ResizeWindow Window.Size


type Cell
    = Live
    | Dead
    | Reborn
