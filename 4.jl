s2int(s) = parse(Int, s)

function parse_board(s)
    lines = split(s, "\n")
    grid = map(s2int, hcat(map(split, lines)...))
    [map(Set, eachrow(grid)); map(Set, eachcol(grid))]
end

function slurp_bingo(filename)
    lines = readlines(filename)
    numbers = map(s2int, split(lines[1], ','))
    boards_string = join(lines[3:end], "\n")
    boards = split(boards_string, "\n\n")
    numbers, map(parse_board, boards)
end


function solve(filename)
    numbers, boards = slurp_bingo(filename)
    for number in numbers
        for board in boards
            broadcast(row -> delete!(row, number), board)
            if min(map(length, board)...) == 0
                return reduce(+, union(board...)) * number
            end
        end
    end
end

solve("4eg.txt")
solve("4.txt")

score(board, number) = reduce(+, union(board...)) * number
completed(board) = min(length.(board)...) == 0
remove(board, number) = broadcast(row -> delete!(row, number), board)

function solve2(filename)
    numbers, boards = slurp_bingo(filename)
    for number in numbers
        for board in boards
            remove(board, number)
            if all(completed, boards)
                return score(board, number)
            end
        end
    end
end

solve2("4eg.txt")
solve2("4.txt") == 2980

