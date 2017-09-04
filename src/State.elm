module State exposing (..)

import Task
import Time exposing (Time, second)
import Types exposing (..)
import LifeMatrix exposing (evolve, initialMatrix)
import Window


matrixSeedData : Task.Task x ( Time, Window.Size )
matrixSeedData =
    Time.now
        |> Task.andThen
            (\now -> Window.size |> Task.map (\size -> ( now, size )))


init : ( Model, Cmd Msg )
init =
    ( { matrix = [ [] ] }, Task.perform SeedMatrix matrixSeedData )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model | matrix = (evolve model.matrix) }, Cmd.none )

        SeedMatrix ( time, windowSize ) ->
            ( { model | matrix = (initialMatrix time windowSize) }, Cmd.none )

        ResizeWindow windowSize ->
            ( model, Task.perform SeedMatrix matrixSeedData )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every second Tick
        , Window.resizes ResizeWindow
        ]
