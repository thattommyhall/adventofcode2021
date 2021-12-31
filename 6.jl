to_int(s) = parse(Int, s)


using DataStructures

function pass_day(fish)
    zero_count = length(filter(==(0), fish))
    fish = map(grow, fish)
    for _ = 1:zero_count
        append!(fish, 8)
    end
    fish
end

function solve(filename, num_days)
    fish = parse_file(filename)
    for day = 1:num_days
        fish = pass_day(fish)
    end
    length(fish)
end

solve("6eg.txt", 80) == 5934
solve("6.txt", 80)

grow(n) = n == 0 ? 6 : n - 1
parse_file(filename) = parse.(Int, split(read(filename, String), ","))

function solve2(filename, num_days)
    fishes = parse_file(filename)
    counts = counter(fishes)
    for _ in 1:num_days
        new_counts = counter(Int)
        for (fish, count) in counts
            new_counts[grow(fish)] = count
        end
        new_counts[8] += new_counts[0]
        counts = new_counts
    end
    sumcounts
end
solve2("6eg.txt", 256)
solve2("6eg.txt", 256) == 26984457539
solve2("6.txt", 80) == 5934
