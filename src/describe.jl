# Based on the describe function of DataFrames.jl
function describe(M::AbstractArray{T}) where T <: Number
    V = sort!(vec(M))
    str  = "Summary Stats for a range of $(length(V)*2 - 2):\n"
    str *= "Mean:           $(mean(V))\n"
    str *= "Minimum:        $(V[1])\n"
    str *= "1st Quartile:   $(quantile(V, 0.25, sorted = true))\n"
    str *= "Median:         $(median(V))\n"
    str *= "3rd Quartile:   $(quantile(V, 0.75, sorted = true))\n"
    str *= "Maximum:        $(V[end])\n"
    str *= "Length:         $(length(V))\n"
    str *= "Type:           $T\n"
    print(str)
end

function describe_diag(M::Matrix{T}) where T <: Number
    l = size(M,1)
    V = [M[i, l + 1 - i] for i in 1:l]
    describe(V)
end