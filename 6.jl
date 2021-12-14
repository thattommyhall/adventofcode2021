to_int(s) = parse(Int, s)

grow(n) = n == 0 ? 6 : n - 1

function pass_day(fish)
    zero_count = length(filter(==(0), fish))
    fish = map(grow, fish)
    for _ = 1:zero_count
        append!(fish, 8)
    end
    fish
end

parse_file(filename) = to_int.(split(read(filename, String), ","))

function solve(filename, num_days)
    fish = parse_file(filename)
    for day = 1:num_days
        fish = pass_day(fish)
    end
    length(fish)
end

solve("6eg.txt", 80) == 5934
solve("6.txt", 80)

function pass_n_days(fish::Int, num_days)
    println("fish!!!! $(fish)")
    fish = [fish]
    for i = 1:num_days
        println(i)
        fish = pass_day(fish)
    end
    fish
end

pass_n_days(3, 13)

function solve2(filename, num_days)
    fishes = parse_file(filename)
    result = 0
    for fish in fishes
        f = pass_n_days(fish, num_days)
        result += length(f)
    end
    result
end

solve2("6eg.txt", 256) == 26984457539
solve2("6.txt", 80) == 5934
