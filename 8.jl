using DataStructures

unscrambled = Dict{String,Int}(
    Set(collect("abcefg")) => 0,
    Set(collect("cf")) => 1,
    Set(collect("acdeg")) => 2,
    Set(collect("acdfg")) => 3, 
    Set(collect("bcdf")) => 4,
    Set(collect("abdfg")) => 5,
    Set(collect("abdefg")) => 6,
    Set(collect("acf")) => 7,
    Set(collect("abcdefg")) => 8,
    Set(collect("abcdfg")) => 9
)

by_count = DefaultDict(Set)
for (k,v) in unscrambled
    push!(by_count[length(k)], k)
end

by_count

parse_file(filename) = [map(split,split(line, " | ")) for line in readlines(filename)]

parse_file("8eg.txt")[1]

function simple(s) 
    l = length(s)
    l == 2 || l == 4 || l == 3 || l == 7
end

function simple2(s)
    length(s) in [2,4,3,7]
end

function lookup_simple(s)
    l = length(s)
    result = Dict{Char,Char}()
    @assert length(by_count[l]) == 1
    target = collect(by_count[l])[1]
    for (idx, char) in enumerate(s)
        result[char] = target[idx]
    end
    result
end

lookup_simple("ae")

solve1(filename) = reduce(+, [length(filter(simple, output)) for (egs, output) in parse_file(filename)])

solve1("8eg.txt")
solve1("8.txt")

function possible_mapping(eg)
    result = DefaultDict(Set{Char})
    l = length(eg)
    targets = by_count[l]
    for target in targets
        for char in eg
            for target_char in target
                push!(result[char], target_char)
            end
        end
    end
    result
end

function get_result(mapping, output)
    display(mapping)
    to_lookup = map(x->mapping[x], collect(output))
    unscrambled[to_lookup]
end

all_chars = collect("abcdefg")
function solveline(egs, outputs)
    mapping = Dict()
    for eg in egs
        if simple(eg)
            for (k,v) in lookup_simple(eg)
                mapping[k] = v
            end
        end
    end
    @assert length(mapping) == 7
    [(mapping, output) for output in outputs]
end



[solveline(line...) for line in parse_file("8eg.txt")]
    
mapping = Dict('f' => 'e', 'g' => 'f', 'c' => 'c', 'd' => 'c', 'e' => 'd', 'a' => 'g', 'b' => 'b')
eg = "gbdfcae"

map(x->mapping[x], collect(eg))

get_result(mapping, eg)