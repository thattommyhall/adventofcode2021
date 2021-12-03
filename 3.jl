function slurp_grid(filename)
    permutedims(hcat(map(collect, readlines(filename))...))
end

eg = slurp_grid("3eg.txt")
input = slurp_grid("3a.txt")

function flip(bitchar)
    if bitchar == '1'
        '0'
    elseif bitchar == '0'
        '1'
    end
end

function gamma(col)
    if length(filter(x -> x == '1', col)) / length(col) >= 0.5
        '1'
    else
        '0'
    end
end

function gamma_rate(m)
    map(gamma, eachcol(m))
end

function to_decimal(bits)
    bitstring = string(bits...)
    parse(Int, bitstring, base = 2)
end

function solve1(m)
    g = gamma_rate(m)
    epsilon_rate = map(flip, g)
    to_decimal(g) * to_decimal(epsilon_rate)
end

solve1(eg)

solve1(input)

function select_max(m, idx)
    max = gamma(m[:, idx])
    permutedims(hcat([row for row in eachrow(m) if row[idx] == max]...))
end

function select_min(m, idx)
    min = flip(gamma(m[:, idx]))
    permutedims(hcat([row for row in eachrow(m) if row[idx] == min]...))
end


function oxygen(m)
    s = size(m, 2)
    for idx = 1:s
        m = select_max(m, idx)
        if size(m, 1) == 1
            return m
        end
    end
end

function co2(m)
    s = size(m, 2)
    for idx = 1:s
        m = select_min(m, idx)
        if size(m, 1) == 1
            return m
        end
    end
end

function solve2(m)
    to_decimal(oxygen(m)) * to_decimal(co2(m))
end

solve2(eg)
solve2(input)
