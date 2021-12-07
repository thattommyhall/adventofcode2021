to_int(s) = parse(Int, s)

diff(x, y) = abs(x-y)

parse_file(filename) = to_int.(split(read(filename, String), ","))

function solve(filename, cost_fn)
    xs = parse_file(filename)
    costs = [sum([cost_fn(i, x) for x in xs]) for i in min(xs...):max(xs...)]
    min(costs...)
end

# Part 1
solve("7eg.txt", diff) == 37
solve("7.txt", diff) == 336701

cost(x,y) = sum(1:diff(x,y))

# Part 2
solve("7eg.txt", cost)
solve("7.txt", cost) 
