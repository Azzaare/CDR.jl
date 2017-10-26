abstract type TotalOrderAlgorithm end

struct CorputSequence <: TotalOrderAlgorithm end

function corput(range::Int)
    loop = ceil(log2(range))

    output = [0]

    for i in 1:loop
        st = output * 2
        nd = st + 1
        output = hcat(st, nd)
    end

    return filter(x -> x < range, output[1,:])
end

function total_order(
    range::Int,                     # range (x and y, or both)
    algorithm::TotalOrderAlgorithm  # keyword argument for the Total Order Generator
        = CorputSequence()
    )
    return corput(range)
end
