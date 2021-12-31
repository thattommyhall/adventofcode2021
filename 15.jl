using DataStructures

CI = CartesianIndex

slurp_grid(filename) = parse.(Int, permutedims(hcat(collect.(readlines(filename))...)))

get_neighbors(idx) = [idx + Δ for Δ in [CI(0, 1), CI(1, 0), CI(-1, 0), CI(0, -1)]]

function in_bounds(grid, idx)
    y_max, x_max = size(grid)
    y, x = Tuple(idx)
    1 <= y <= y_max && 1 <= x <= x_max
end

get_neighbors(grid, idx) = [idx for idx in get_neighbors(idx) if in_bounds(grid, idx)]

function a_star(start, neighbors_fn, heuristic, step_cost)
    frontier = PriorityQueue()
    enqueue!(frontier, start, heuristic(start))
    previous = Dict{CI,Union{Nothing,CI}}(start => nothing)
    path_cost = Dict(start => 0)
    path = function (idx)
        result = []
        while idx !== nothing
            push!(result, idx)
            idx = previous[idx]
        end
        reverse(result)
    end
    
    while !isempty(frontier)
        next = dequeue!(frontier)
        if heuristic(next) == 0
            return path(next)
        end
        for idx in neighbors_fn(next)
            g = path_cost[next] + step_cost(next, idx)
            if !haskey(path_cost, idx) || g < path_cost[idx]
                frontier[idx] = g + heuristic(idx)
                path_cost[idx] = g
                previous[idx] = next
            end
        end
    end
end

function a_star_path(grid, start, goal)
    neighbors_fn(idx) = get_neighbors(grid, idx)
    heuristic(idx) = sum(Tuple(goal - idx))
    step_cost(from, to) = grid[to]
    a_star(start, neighbors_fn, heuristic, step_cost)
end

plus_mod(n) = x -> mod1(x + n, 9)

expand_map(grid) = [
    plus_mod(0).(grid) plus_mod(1).(grid) plus_mod(2).(grid) plus_mod(3).(grid) plus_mod(4).(grid)
    plus_mod(1).(grid) plus_mod(2).(grid) plus_mod(3).(grid) plus_mod(4).(grid) plus_mod(5).(grid)
    plus_mod(2).(grid) plus_mod(3).(grid) plus_mod(4).(grid) plus_mod(5).(grid) plus_mod(6).(grid)
    plus_mod(3).(grid) plus_mod(4).(grid) plus_mod(5).(grid) plus_mod(6).(grid) plus_mod(7).(grid)
    plus_mod(4).(grid) plus_mod(5).(grid) plus_mod(6).(grid) plus_mod(7).(grid) plus_mod(8).(grid)
]

function solve2(filename)
    grid = expand_map(slurp_grid(filename))
    CIs = CartesianIndices(grid)
    path = a_star_path(grid, first(CIs), last(CIs))
    reduce(+, [grid[idx] for idx in path if idx != first(CIs)])
end

solve2("15eg.txt") == 315 
solve2("15.txt")

