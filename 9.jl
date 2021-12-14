using PaddedViews

to_int(s) = parse(Int, s)

slurp_grid(filename) = to_int.(permutedims(hcat(map(collect, readlines(filename))...)))

function pad(m)
    y, x = size(m)
    PaddedView(10, m, (0:y+1, 0:x+1), (1:y, 1:x))
end

get_neighbors((y, x)) = [[y + 1, x], [y - 1, x], [y, x + 1], [y, x - 1]]
get_neighbors_values(m, (y, x)) = [m[pos...] for pos in get_neighbors([y, x])]
function is_low(m, (y, x))
    current = m[y, x]
    neighborhood = get_neighbors_values(m, [y, x])
    length(filter(<=(current), neighborhood)) == 0
end

function solve1(filename)
    m = slurp_grid(filename)
    y_max, x_max = size(m)
    p = pad(m)
    sum([1 + p[y, x] for y = 1:y_max for x in 1:x_max if is_low(p, pos)])
end

solve1("9eg.txt") == 15
solve1("9.txt") == 535

function get_low_points(m)
    p = pad(m)
    [idx for idx in size(m) if is_low(p, idx)]
end

get_basin_neighbors(m, (y, x)) = [n for n in get_neighbors([y, x]) if m[n...] < 9]

function basin_size(m, pos)
    m = pad(m)
    explored = Set()
    unexplored = Set([pos])
    while !isempty(unexplored)
        current = pop!(unexplored)
        push!(explored, current)
        neighbors = get_basin_neighbors(m, current)
        for neighbor in neighbors
            if neighbor ∉ explored
                push!(unexplored, neighbor)
            end
        end
    end
    length(explored)
end

function solve2(filename)
    m = slurp_grid(filename)
    sorted = sort([basin_size(m, pos) for pos in get_low_points(m)], rev = true)
    reduce(*, sorted[1:3])
end

solve2("9eg.txt") == 1134
solve2("9.txt") == 1122700
