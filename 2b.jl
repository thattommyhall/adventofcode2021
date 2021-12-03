instructions = readlines("2a.txt")

struct Pos
    x::Any
    depth::Any
    aim::Any
end

forward(p::Pos, amount) = Pos(p.x + amount, p.depth + p.aim * amount, p.aim)
up(p::Pos, amount) = Pos(p.x, p.depth, p.aim - amount)
down(p::Pos, amount) = Pos(p.x, p.depth, p.aim + amount)

function fn_named(name)
    getfield(Main, Symbol(name))
end

pos = Pos(0, 0, 0)
for instruction in instructions
    direction, amount = split(instruction)
    amount = parse(Int, amount)
    pos = fn_named(direction)(pos, amount)
end

pos.x * pos.depth 
