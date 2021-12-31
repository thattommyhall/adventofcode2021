using Transducers
# using Folds
using Profile
using DataStructures

function slurp_file(filename)
    lines = readlines(filename)
    template = collect(lines[1])
    rules = split.(lines[3:end], " -> ")
    template, rules
end

template, rules = slurp_file("14eg.txt")

function rules_to_f(rules)
    mapping = DefaultDict(Dict)
    for (pair, to_insert) in rules
        left, right = collect(pair)
        mapping[left][right] = only(to_insert)
    end
    function (left, right)
        if haskey(mapping, left) && haskey(mapping[left], right)
            mapping[left][right]
        else
        end
    end
end

f = rules_to_f(rules)

function insertions(s, rule_f)
    result = s |> Consecutive(2, 1) |> MapCat(rule_f) |> collect
    push!(result, s[length(s)])
    result
end

function insertions2(s, rule_f)
    left = s[1]
    result = Vector()
    for right in s[2:end]
        push!(result, left)
        to_insert = rule_f(left, right)
        if !isnothing(to_insert)
            push!(result, to_insert)
        end
        left = right
    end
    push!(result, s[end])
    result
end

insertions2(template, f)
insertions2(template, f) == collect("NCNBCHB")

function solve(filename, steps)
    template, rules = slurp_file(filename)
    rule_f = rules_to_f(rules)
    for c = 1:steps
        template = insertions2(template, rule_f)
    end
    vals = values(counter(template))
    max(vals...) - min(vals...)
end

solve1(filename) = solve(filename, 10)

solve1("14.txt") == 2975

to_pair_counts(template) = counter(collect(Consecutive(2,1)(template)))

function to_letter_counts(counts)
    result = counter(Char)
    for ((l,r), count) in counts
        result[l] += count
        result[r] += count
    end
    map!(x -> iseven(x) ? x/2 : (x+1)/2, values(result))
    result
end

function solve2(filename, num_steps)
    template, rules = slurp_file(filename)
    rule_f = rules_to_f(rules)
    counts = to_pair_counts(template)
    for c = 1:num_steps
        new_counts = counter(Tuple{Char, Char})
        for ((l,r), count) in counts
            new = rule_f(l,r)
            new_counts[(l, new)] += count
            new_counts[(new, r)] += count            
        end
        counts = new_counts
    end
    letter_counts = to_letter_counts(counts)
    vals = values(letter_counts)
    max(vals...) - min(vals...)
end

solve2("14.txt", 10) == 2975
solve2("14.txt", 40) 
