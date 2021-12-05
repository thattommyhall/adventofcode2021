s2int(s) = parse(Int, s)

function parse_board(s)
    lines = split(s, "\n")
    grid = hcat(map(split, lines)...)
    [map(Set, eachrow(grid));map(Set, eachcol(grid))]
end

eg_board = "14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"

eg = parse_board(eg_board)
eg
function slurp_bingo(filename)
    lines = readlines(filename)
    numbers = split(lines[1], ',')
    boards_string = join(lines[3:end], "\n")
    boards = split(boards_string, "\n\n")
    numbers, map(parse_board, boards)
end


function solve(filename)
    numbers, boards = slurp_bingo(filename)
    for number in numbers
        for board in boards
            broadcast(row->delete!(row,number), board)
        end
        for board in boards
            for line in board
                if length(line) == 0
                    return board
                end
            end
        end
    end 
end

solve("")