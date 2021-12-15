using PaddedViews

to_int(s) = parse(Int, s)

slurp_grid(filename) = to_int.(permutedims(hcat(map(collect, readlines(filename))...)))

function pad(m)
    y, x = size(m)
    PaddedView(10, m, (0:y+1, 0:x+1), (1:y, 1:x))
end

function get_neighbors(idx)
    y, x = Tuple(idx)
    [
        CartesianIndex(y + 1, x),
        CartesianIndex(y - 1, x),
        CartesianIndex(y, x + 1),
        CartesianIndex(y, x - 1),
    ]
end

get_neighbors_values(m, idx) = [m[idx] for idx in get_neighbors(idx)]
function is_low(m, idx)
    current = m[idx]
    neighborhood = get_neighbors_values(m, idx)
    length(filter(<=(current), neighborhood)) == 0
end

function solve1(filename)
    m = slurp_grid(filename)
    p = pad(m)
    sum([1 + p[idx] for idx in CartesianIndices(m) if is_low(p, idx)])
end

solve1("9eg.txt") == 15
solve1("9.txt") == 535

function get_low_points(m)
    p = pad(m)
    [idx for idx in CartesianIndices(m) if is_low(p, idx)]
end

get_basin_neighbors(m, idx) = [idx_ for idx_ in get_neighbors(idx) if m[idx_] < 9]

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

solve2("9eg.txt") 
solve2("9.txt") 


