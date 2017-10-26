abstract type Dimension end

struct Dim2 <: Dimension end
struct Dim3 <: Dimension end

const Sequence = Vector{Int}
const Sequences = Vector{Sequence}

function cdr(
    x::Int,
    y::Int,
    sequence::Sequence,
    dim::Dim2
    )
    direction = ones(Int, x + y)

    filter_sequence = filter(a -> a < x + y, sequence)

    for i in 1:x
        direction[filter_sequence[i] + 1] = 0
    end

    path = zeros(Int, 2, x + y + 1)

    for i in 2:(x + y + 1)
        if direction[i - 1] == 0
            move = [1, 0]
        else
            move = [0, 1]
        end
        path[:, i] = path[:, i - 1] + move
    end

    return path
end

function cdr(
    x::Int,
    y::Int,
    sequences::Sequences;
    dim::Dimension = Dim2()
    )
    return cdr(x, y, sequences[1], dim)
end
