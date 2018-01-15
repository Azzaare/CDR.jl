function best_neighbor(
    M::Matrix{T},
    k::Integer,
    x::Int,
    y::Int
    ) where T <: Number
    δ = M[x,y]
    n = size(M,1)
    for i in 0:k
        for j in 0:k-i
            if x - i > 0
                if y - j > 0
                    δ = min(δ, M[x - i, y - j])
                end
                if y + j ≤ n
                    δ = min(δ, M[x - i, y + j])
                end
            end
            if x + i ≤ n
                if y - j > 0
                    δ = min(δ, M[x + i, y - j])
                end
                if y + j ≤ n
                    δ = min(δ, M[x + i, y + j])
                end 
            end
        end
    end
    return δ
end

function neighbors_map(
    M::Matrix{T};
    d::Integer = 1
    ) where T <: Number
    
    return [best_neighbor(M, d, x, y) for x in 1:size(M,1), y in 1:size(M,2)]
end