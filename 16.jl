bin2int(s::String) = parse(Int, s, base = 2)

function hex_to_bin(c::Char)
    i = parse(Int, string(c), base = 16)
    string(i, base = 2, pad = 4)
end

slurp_string(s) = string(hex_to_bin.(collect(s))...)
slurp_file(filename) = slurp_string(readlines(filename)[1])

function gobble_literal(s)
    literal = ""
    while true
        f = s[1]
        next = s[2:5]
        literal *= next
        if f == '0'
            return bin2int(literal), s[6:end]
        end
        s = s[6:end]
    end
end

gobble_literal("101111111000101000") == (2021, "000")

struct Literal
    version::Int
    value::Int
end

struct Operator
    version::Int
    type_id::Int
    subpackets::Vector{Union{Operator,Literal}}
end

function parse_header(s)
    version = bin2int(s[1:3])
    type_id = bin2int(s[4:6])
    remaining = s[7:end]
    version, type_id, remaining
end

function gobble_packet(s)
    version, type_id, remaining = parse_header(s)
    if type_id == 4
        value, remaining = gobble_literal(remaining)
        return Literal(version, value), remaining
    else
        length_type_id = remaining[1]
        if length_type_id == '1'
            num_packets = bin2int(remaining[2:12])
            subpackets, remaining = parse_n_subpackets(num_packets, remaining[13:end])
            return Operator(version, type_id, subpackets), remaining
        end
        if length_type_id == '0'
            l = bin2int(remaining[2:16])
            subpackets, remaining = parse_subpackets_l(l, remaining[17:end])
            return Operator(version, type_id, subpackets), remaining
        end
    end
end

function parse_subpackets_l(l, s)
    result = []
    to_parse = s[1:l]
    remaining = s[l+1:end]
    while length(to_parse) > 7
        next, to_parse = gobble_packet(to_parse)
        push!(result, next)
    end
    result, remaining
end

function parse_n_subpackets(n, s)
    result = []
    for _ = 1:n
        packet, s = gobble_packet(s)
        push!(result, packet)
    end
    result, s
end

parse_subpackets_l(27, "1101000101001010010001001000000000")

eg, remaining = gobble_packet("11101110000000001101010000001100100000100011000001100000")

gobble_packet("00111000000000000110111101000101001010010001001000000000")

gobble_packet(slurp_file("16.txt"))

get_versions(o::Operator) = get_versions(o, [])

function get_versions(o::Operator, so_far)
    push!(so_far, o.version)
    for item in o.subpackets
        for version in get_versions(item)
            push!(so_far, version)
        end
    end
    so_far
end

get_versions(l::Literal) = [l.version]

get_versions(eg)

function solve_s(s)
    parsed, _ = gobble_packet(slurp_string(s))
    sum(+, get_versions(parsed))
end

function solve(filename)
    parsed, _ = gobble_packet(slurp_file(filename))
    sum(+, get_versions(parsed))
end

eval(l::Literal) = l.value

f_lookup = Dict(
    0 => sum,
    1 => values -> reduce(*, values),
    2 => values -> min(values...),
    3 => values -> max(values...),
    5 => values -> first(values) > last(values) ? 1 : 0,
    6 => values -> first(values) < last(values) ? 1 : 0,
    7 => values -> all(==(first(values)), values),
)

function eval(p::Operator)
    values = map(eval, p.subpackets)
    f = f_lookup[p.type_id]
    f(values)
end

function eval(s::AbstractString)
    exp, _ = gobble_packet(slurp_string(s))
    eval(exp)
end

eval_file(filename) = eval(readlines(filename)[1])

eval("C200B40A82")
eval("9C0141080250320F1802104A08") == 1

eval_file("16.txt")



