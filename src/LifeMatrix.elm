module LifeMatrix exposing (evolve, initialMatrix)

import Debug
import Matrix
import Maybe exposing (withDefault)
import Random
import Types exposing (..)
import View exposing (cellWidth, cellHeight)
import Window


numberOfRows : Int -> Int
numberOfRows windowHeight =
    windowHeight // cellHeight


numberOfColumns : Int -> Int
numberOfColumns windowWidth =
    let
        buffer =
            1
    in
        (windowWidth // cellWidth) - buffer


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


chunkIntoRows : List a -> Int -> List (List a) -> List (List a)
chunkIntoRows cells cols rows =
    if List.length cells > 0 then
        let
            newRow =
                [ List.take cols cells ]

            rowsConcat =
                if List.length rows > 0 then
                    rows ++ newRow
                else
                    newRow
        in
            chunkIntoRows (List.drop cols cells) cols rowsConcat
    else
        rows


initialMatrix : Float -> Window.Size -> List (List Cell)
initialMatrix randomSeed windowSize =
    let
        rows =
            numberOfRows windowSize.height

        cols =
            numberOfColumns windowSize.width

        ( cells, _ ) =
            Random.step
                (Random.list (rows * cols) (Random.int 0 1))
                (Random.initialSeed (round randomSeed))
    in
        chunkIntoRows (List.map numToCell cells) cols []


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
