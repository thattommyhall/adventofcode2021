using DataStructures

slurp_grid(filename) = parse.(Int8, permutedims(hcat(collect.(readlines(filename))...)))

get_neighbors(idx) = [idx + CartesianIndex(Δx, Δy) for Δx = -1:1 for Δy in -1:1 if !(Δx == Δy == 0)]

function in_bounds(grid, idx)
    y_max, x_max = size(grid)
    y, x = Tuple(idx)
    1 <= y <= y_max && 1 <= x <= x_max
end

get_neighbors(grid, idx) = [idx for idx in get_neighbors(idx) if in_bounds(grid, idx)]

get_neighbors(CartesianIndex(1, 1))

function step(grid, num_flashes)
    flashed = []
    to_increment = []
    grid = (i -> i + 1).(grid)
    for idx in CartesianIndices(grid)
        if grid[idx] > 9
            push!(flashed, idx)
            for idx_ in get_neighbors(grid, idx)
                if idx_ ∉ flashed
                    push!(to_increment, idx_)
                end
            end
        end
    end
    while !isempty(to_increment)
        next = pop!(to_increment)
        grid[next] += 1
        if grid[next] > 9 && next ∉ flashed
            push!(flashed, next)
            for idx in get_neighbors(grid, next)
                if idx ∉ flashed
                    push!(to_increment, idx)
                end
            end
        end
    end
    grid = (i -> i > 9 ? 0 : i).(grid)
    grid, num_flashes + length(flashed)
end

function solve1(filename)
    grid = slurp_grid(filename)
    num_flashes = 0
    for _ = 1:100
        grid, num_flashes = step(grid, num_flashes)
    end
    num_flashes
end

solve1("11eg.txt") == 1656
solve1("11.txt")

function step(grid)
    flashed = []
    to_increment = []
    grid = (i -> i + 1).(grid)
    for idx in CartesianIndices(grid)
        if grid[idx] > 9
            push!(flashed, idx)
            for idx_ in get_neighbors(grid, idx)
                if idx_ ∉ flashed
                    push!(to_increment, idx_)
                end
            end
        end
    end
    while !isempty(to_increment)
        next = pop!(to_increment)
        grid[next] += 1
        if grid[next] > 9 && next ∉ flashed
            push!(flashed, next)
            for idx in get_neighbors(grid, next)
                if idx ∉ flashed
                    push!(to_increment, idx)
                end
            end
        end
    end
    (i -> i > 9 ? 0 : i).(grid)
end

function solve2(filename)
    grid = slurp_grid(filename)
    count = 0
    while !all(==(0), grid)
        grid = step(grid)
        count += 1
    end
    count
end

solve2("11eg.txt")
solve2("11.txt")
