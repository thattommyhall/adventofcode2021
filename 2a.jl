instructions = readlines("2a.txt")

struct Pos
    x
    z
end

function update_position(pos, direction, amount)
    if direction == "forward"
        Pos(pos.x+amount, pos.z)
    elseif direction == "up"
        Pos(pos.x, pos.z - amount)
    elseif direction == "down"
        Pos(pos.x, pos.z + amount)
    end
end


pos = Pos(0,0)
for instruction in instructions
    direction, amount = split(instruction)
    amount = parse(Int, amount)
    pos = update_position(pos, direction, amount)
end

pos.x*pos.z
