using DataStructures

function slurp_map(filename)
    result = DefaultDict(Set)
    for (from, to) in split.(readlines(filename), "-")
        push!(result[from], to)
        push!(result[to], from)
    end
    for (_, reachable) in result
        delete!(reachable, "start")
    end
    result
end

slurp_map("12eg1.txt")

function islower(s)
    if s == "start"
        false
    elseif s == "end"
        false
    else
        islowercase(s[1])
    end
end

function count_paths(current::AbstractString, links::AbstractDict)
    if current == "end"
        1
    elseif isempty(links[current])
        0
    else
        path_count = 0
        new_links = deepcopy(links)
        if islower(current)
            for (from, tos) in new_links
                delete!(tos, current)
            end
        end
        for next in links[current]
            path_count += count_paths(next, deepcopy(new_links))
        end
        path_count
    end
end

count_paths(links::AbstractDict) = count_paths("start", links)

count_paths(slurp_map("12eg1.txt")) == 10
count_paths(slurp_map("12eg2.txt")) == 19
count_paths(slurp_map("12eg3.txt")) == 226
count_paths(slurp_map("12.txt"))

function count_paths2(current::AbstractString, links::AbstractDict, small_visited::AbstractDict)
    links = deepcopy(links)
    small_visited = deepcopy(small_visited)
    if current == "end"
        1
    elseif isempty(links[current])
        0
    else
        path_count = 0
        if islower(current)
            small_visited[current] += 1
        end
        for next in links[current]
            if islower(next) && any(>=(2), values(small_visited))
                if small_visited[next] == 0
                    path_count += count_paths2(next, links, small_visited)
                end
            else
                path_count += count_paths2(next, links, small_visited)
            end
        end
        path_count
    end
end

count_paths2(links::AbstractDict) = count_paths2("start", links, DefaultDict(0))

count_paths2(slurp_map("12eg1.txt"))
count_paths2(slurp_map("12eg2.txt"))
count_paths2(slurp_map("12eg3.txt")) == 3509

count_paths2(slurp_map("12.txt"))

