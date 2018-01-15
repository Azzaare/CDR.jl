#abstract type Dimension end

#struct Dim2 <: Dimension end
#struct Dim3 <: Dimension end

const Sequence = Vector{Int}
const Sequences = Vector{Sequence}

function cdr(
    x::Int,
    y::Int,
    sequence::Sequence
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

# function cdr(
#     x::Int,
#     y::Int,
#     sequences::Sequences,
#     dim::Dimension = Dim2()
#     )
#     return cdr(x, y, sequences[1], dim)
# end

function cdr(
    x::Int,
    y::Int,
    z::Int,
    sequence::Sequence
    )

    direction = zeros(Int, x + y + z)
    # 0 = x
    # 1 = y
    # 2 = z

    filter_sequence = filter(a -> a < x + y + z, sequence)

    for i in x+1:x+y
        direction[filter_sequence[i] + 1] = 1
    end
    for i in x+y+1:x+y+z
        direction[filter_sequence[i] + 1] = 2
    end

    path = zeros(Int, 3, x + y + z + 1)

    for i in 2:(x + y + z + 1)
        if direction[i - 1] == 0
            move = [1, 0, 0]
        elseif direction[i - 1] == 1
            move = [0, 1, 0]
        else
            move = [0, 0, 1]
        end
        path[:, i] = path[:, i - 1] + move
    end

    return path
end
