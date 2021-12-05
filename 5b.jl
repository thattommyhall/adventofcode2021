to_int(s) = parse(Int, s)

str2tuple(s) = (x -> x + 1).(to_int.(split(s, ',')))

parse_line(line) = str2tuple.(split(line, " -> "))

function line_to_points((x1, y1), (x2, y2))
    if x1 == x2
        [(y, x1) for y = min(y1, y2):max(y1, y2)]
    elseif y1 == y2
        [(y1, x) for x = min(x1, x2):max(x1, x2)]
    else
        Δx = x2 > x1 ? 1 : -1
        Δy = y2 > y1 ? 1 : -1
        [(y1 + Δy * n, x1 + Δx * n) for n = 0:abs(x1 - x2)]
    end
end

function solve2(filename)
    board = zeros(1000, 1000)
    for line in readlines(filename)
        points = line_to_points(parse_line(line)...)
        for point in points
            board[point...] += 1
        end
    end
    length(filter(>=(2), board))
end

solve2("5.txt")
