using Transducers

nums = [parse(Int, x) for x in readlines("1a.txt")]

increasing((x,y)) = x<y

nums |> Partition(3,1) |> Map(sum) |> Partition(2,1) |> Filter(increasing) |> collect |> size 