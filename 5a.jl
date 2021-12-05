to_int(s) = parse(Int, s)

str2tuple(s) = (x->x+1).(to_int.(split(s, ',')))  

parse_line(line) = str2tuple.(split(line, " -> "))

function line_to_points((x1, y1), (x2, y2))
    display([x1,y1,x2,y2])
    if x1 == x2
        ys = min(y1, y2):max(y1, y2)
        ys, x1
    elseif y1 == y2
        xs = min(x1, x2):max(x1, x2)
        y1, xs
    end
end

line_to_points(parse_line("0,9 -> 5,9")...)

function solve1(filename)
    board = zeros(1000, 1000)
    for line in readlines(filename)
        points = line_to_points(parse_line(line)...)
        display(points)
        if !isnothing(points)
            board[points...] .+= 1
        end
    end
    length(filter(>=(2), board))
end

solve1("5.txt")
