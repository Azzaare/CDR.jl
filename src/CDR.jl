module CDR

# package code goes here
using Plotly

export hausdorff_map, hausdorff_plot_surface, hausdorff_plot_heatmap, hausdorff_plot_heatmap_log

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

function cdr(x::Int, y::Int, sequence::Vector{Int})
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

function hausdorff(path::Matrix{Int})
    l = size(path,2)

    line = path[:, l] - path[:, 1]
    # println(path[:, l] - path[:, 1])
    perp = [line[2], -line[1]]

    dist = 0

    for i in 2:(l - 1)
        d = ( (path[1, i] - path[1, 1]) * perp[1] + (path[2, i] - path[2, 1]) * perp[2] ) / norm(perp)
        dist = max(dist, d)
    end

    return dist
end

function hausdorff_map(range::Int)
    sequence = corput(range)

    M = zeros(Float64, range/2 + 1, range/2 + 1)
    for j in 0:Int(range/2)
        for i in 0:Int(range/2)
            path = cdr(i, j, sequence)
            M[i + 1, j + 1] = hausdorff(path)
        end
    end
    return M
end

function hausdorff_plot_surface(range::Int)
    M = hausdorff_map(range)
    z = [M[i,:] for i in 1:size(M,1)]
    trace = surface(z=z)
    layout = Layout(title="Haussdorf distance surface map")
    plot(trace, layout)
end

function hausdorff_plot_heatmap(range::Int)
    M = hausdorff_map(range)
    z = [M[i,:] for i in 1:size(M,1)]
    trace = heatmap(z=z)
    layout = Layout(title="Haussdorf distance heat map",autosize=false, width=500, height=500, margin=attr(l=0, r=0, b=0, t=65))
    plot(trace, layout)
end

function hausdorff_plot_heatmap_log(range::Int)
    M = hausdorff_map(range) / log2(range)
    z = [M[i,:] for i in 1:size(M,1)]
    trace = heatmap(z=z)
    layout = Layout(title="Haussdorf distance/log2 heat map",autosize=false, width=500, height=500, margin=attr(l=0, r=0, b=0, t=65))
    plot(trace, layout)
end

end # module
