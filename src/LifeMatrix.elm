module LifeMatrix exposing (evolve, initialMatrix)

import Debug
import Matrix
import Maybe exposing (withDefault)
import Random
import Types exposing (..)


numberOfRows : number
numberOfRows =
    10


numberOfColumns : number
numberOfColumns =
    20


numToCell : number -> Cell
numToCell i =
    case (i) of
        0 ->
            Dead

        _ ->
            Live


livingCell : Cell -> Bool
livingCell cell =
    cell == Live || cell == Reborn


chunkIntoRows : List a -> List (List a) -> List (List a)
chunkIntoRows cells rows =
    if List.length cells > 0 then
        let
            newRow =
                [ List.take numberOfColumns cells ]

            rowsConcat =
                if List.length rows > 0 then
                    rows ++ newRow
                else
                    newRow
        in
            chunkIntoRows (List.drop numberOfColumns cells) rowsConcat
    else
        rows


initialMatrix : Float -> List (List Cell)
initialMatrix randomSeed =
    let
        ( cells, _ ) =
            Random.step
                (Random.list (numberOfRows * numberOfColumns) (Random.int 0 1))
                (Random.initialSeed (round randomSeed))
    in
        chunkIntoRows (List.map (\c -> numToCell c) cells) []


evolve : List (List Cell) -> List (List Cell)
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


transformCell : Matrix.Location -> Matrix.Matrix Cell -> Cell
transformCell loc matrix =
    let
        cell =
            (withDefault Dead (Matrix.get loc matrix))

        row =
            (Matrix.row loc)

        col =
            (Matrix.col loc)

        neighbors =
            List.map (\x -> (withDefault Dead x))
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
            List.length (List.filter livingCell neighbors)

        isAlive =
            livingCell cell
    in
        if not isAlive && (liveNeighbors == 3) then
            --- reproduction
            Reborn
        else if (liveNeighbors < 2) then
            -- loneliness
            Dead
        else if isAlive && (liveNeighbors > 1) && (liveNeighbors < 4) then
            -- stasis
            cell
        else if (liveNeighbors > 3) then
            -- overcrowding
            Dead
        else
            -- in practice: already dead, two neighbors
            cell
