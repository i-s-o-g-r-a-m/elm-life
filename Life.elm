module Main exposing (..)

import Debug
import Html exposing (Html, div, text)
import List
import Maybe exposing (withDefault)
import Random
import Task
import Time exposing (Time, second)
import Matrix


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( { matrix = [ [] ] }
    , Task.perform (\t -> SeedMatrix t) Time.now
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


transformCell loc matrix =
    let
        cell =
            (withDefault 0 (Matrix.get loc matrix))

        row =
            (Matrix.row loc)

        col =
            (Matrix.col loc)

        neighbors =
            List.map (\x -> (withDefault 0 x))
                [ (Matrix.get ( row - 1, col - 1 ) matrix)
                , (Matrix.get ( row - 1, col ) matrix)
                , (Matrix.get ( row - 1, col + 1 ) matrix)
                , (Matrix.get ( row, col - 1 ) matrix)
                , (Matrix.get ( row, col + 1 ) matrix)
                , (Matrix.get ( row + 1, col - 1 ) matrix)
                , (Matrix.get ( row + 1, col ) matrix)
                , (Matrix.get ( row + 1, col + 1 ) matrix)
                ]

        liveNeighbors =
            List.length (List.filter (\x -> x == 1) neighbors)

        deadNeighbors =
            List.length (List.filter (\x -> x == 0) neighbors)
    in
        if cell == 0 && (liveNeighbors == 3) then
            1
        else if (liveNeighbors < 2) then
            0
        else if cell == 1 && ((liveNeighbors > 1) && (liveNeighbors < 4)) then
            cell
        else if (liveNeighbors > 3) then
            0
        else
            cell


evolve matrix =
    let
        m =
            Matrix.fromList matrix

        transformed =
            Matrix.mapWithLocation
                (\location _ -> transformCell location m)
                m
    in
        Matrix.toList transformed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
    div [] (List.map (\row -> div [] (List.map renderCell row)) model.matrix)


renderCell cell =
    text
        (if cell == 0 then
            "-"
         else
            "o"
        )
