module State exposing (..)

import Task
import Time exposing (Time, second)
import Types exposing (..)
import LifeMatrix exposing (evolve, initialMatrix)


init : ( Model, Cmd Msg )
init =
    ( { matrix = [ [] ] }
    , Task.perform SeedMatrix Time.now
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model | matrix = (evolve model.matrix) }, Cmd.none )

        SeedMatrix t ->
            ( { model | matrix = (initialMatrix t) }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick
