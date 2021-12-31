using DataStructures
using Formatting
import Statistics

slurp_file(filename) = collect.(readlines(filename))

parens = Dict(
    '{' => '}',
    '<' => '>',
    '(' => ')',
    '[' => ']'
)

opening_chars = Set(keys(parens))
closing_chars = Set(values(parens))

function first_error(line)
    opened = Stack{Char}()
    for char in line
        if isempty(opened)
            if char in closing_chars
                return char
            else
                push!(opened, char)
            end
        else
            opening_char = first(opened)
            if char == parens[opening_char]
                pop!(opened)
            elseif char in closing_chars
                return char
            else
                push!(opened, char)
            end
        end
    end
    return ' '
end

scores = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
    ' ' => 0
)

function solve1(filename)
    reduce(+, (c->scores[c]).(first_error.(slurp_file(filename))))           
end

solve1("10eg.txt")
solve1("10.txt")

function get_closing(line)
    opened = Stack{Char}()
    for char in line
        if isempty(opened)
            if char in closing_chars
                return char
            else
                push!(opened, char)
            end
        else
            opening_char = first(opened)
            if char == parens[opening_char]
                pop!(opened)
            elseif char in closing_chars
                return char
            else
                push!(opened, char)
            end
        end
    end
    result = []
    for c in opened
        push!(result, parens[c])
    end
    result
end

scores2 = Dict(
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
)

function score2(chars)
    result = 0
    for char in chars
        result *= 5
        result += scores2[char]
    end
    result
end

score2(collect("}}]])})]")) == 288957

function solve2(filename)
    lines = [line for line in slurp_file(filename) if first_error(line) == ' ']
    println(length(lines))
    scores = score2.(get_closing.(lines))
    @show scores
    sorted = sort(scores)
    Statistics.median(sorted)
end
solve2("10eg.txt") == 288957
format(solve2("10.txt"))
