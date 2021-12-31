using SparseArrays
using OffsetArrays
using Colors
function slurp_file(filename)
    coords, folds = split(read(filename, String), "\n\n")
    coords = [parse.(Int, t) for t in split.(split(coords, "\n"), ",")]
    folds = split(folds, "\n")
    Set(coords), folds
end

coords, folds = slurp_file("13.txt")

function fold(grid, fold_line, idx)
    result = Set{Vector{Int}}()
    for p in grid
        p[idx] = p[idx] > fold_line ? fold_line - (p[idx] - fold_line) : p[idx]
        push!(result, p)
    end
    result
end

function solve(filename)
    coords, folds = slurp_file(filename)
    for f in folds
        axis, line = match(r"fold along ([xy])=(\d+)", f)
        line = parse(Int, line)
        idx = axis == "x" ? 1 : 2
        @show axis, line
        coords = fold(coords, line, idx)
    end
    coords
end

function draw(coords)
    result = zeros(50, 50)
    result = OffsetArray(result, 0:49, 0:49)
    for idx in coords
        y, x = idx
        result[x,y] = 20
    end
    Gray.(result)
end

soln = solve("13.txt")
max(last.(soln)...)

soln

draw(soln)
