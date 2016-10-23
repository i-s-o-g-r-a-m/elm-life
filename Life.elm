module Main exposing (..)

import Debug
import Html exposing (Html, div, text)
import Html.App as App
import List
import Random
import String
import Task
import Time exposing (Time, second)


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( { matrix = [ [] ] }
    , Task.perform (\a -> a) (\t -> SeedMatrix t) Time.now
    )



-- MODEL


type alias Model =
    { matrix : List (List Int) }


rowsCount =
    20


colsCount =
    20


chunkIntoRows : List a -> List (List a) -> List (List a)
chunkIntoRows cells rows =
    if List.length cells > 0 then
        let
            newRow =
                [ List.take colsCount cells ]

            rowsConcat =
                if List.length rows > 0 then
                    rows ++ newRow
                else
                    newRow
        in
            chunkIntoRows (List.drop colsCount cells) rowsConcat
    else
        rows


initialMatrix : Float -> List (List Int)
initialMatrix randomSeed =
    let
        ( cells, _ ) =
            Random.step
                (Random.list (rowsCount * colsCount) (Random.int 0 1))
                (Random.initialSeed (round randomSeed))
    in
        chunkIntoRows cells []



-- UPDATE


type Msg
    = Tick Time
    | SeedMatrix Float


evolve matrix =
    matrix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "tick" "tock"
    in
        case msg of
            Tick _ ->
                ( { model | matrix = (evolve model.matrix) }, Cmd.none )

            SeedMatrix t ->
                ( { model | matrix = (initialMatrix t) }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    div []
        (List.map
            (\row ->
                div []
                    (List.map
                        (\cell -> text (toString cell))
                        row
                    )
            )
            model.matrix
        )
