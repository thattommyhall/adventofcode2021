function slurp_grid(filename)
    permutedims(hcat(map(collect, readlines(filename))...))
end

make_ints(m) = map(x -> parse(Int, x), m)

eg = make_ints(slurp_grid("3eg.txt"))
input = make_ints(slurp_grid("3a.txt"))

function flip(bit)
    if bit == 1
        0
    elseif bit == 0
        1
    end
end

function gamma(col)
    if sum(col) / length(col) > 0.5
        1
    else
        0
    end
end

function gamma_rate(m)
    map(gamma, eachcol(m))
end

function to_decimal(bits)
    bitstring = string(bits...)
    parse(Int, bitstring, base=2)
end

function solve1(m)
    g = gamma_rate(m)
    epsilon_rate = map(flip, g)
    to_decimal(g) * to_decimal(epsilon_rate)
end

solve1(eg)

solve1(input)

