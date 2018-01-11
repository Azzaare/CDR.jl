abstract type PlotType end
struct SurfacePlot <: PlotType end
struct HeatMapPlot <: PlotType end

abstract type DistanceWeight end
struct NormalWeight <: DistanceWeight end
struct Log2Weight <: DistanceWeight end

function hausdorff_distance(
    path::Matrix{Int}
    )
    l = size(path,2)

    line = path[:, l] - path[:, 1]
    perp = [line[2], -line[1]]

    dist = 0

    for i in 2:(l - 1)
        d = ( (path[1, i] - path[1, 1]) * perp[1] + (path[2, i] - path[2, 1]) * perp[2] ) / norm(perp)
        dist = max(dist, d)
    end

    return dist
end

function weight(
    range::Int,
    weightType::NormalWeight
    )
    return (i, j) -> 1
end

function weight(
    range::Int,
    weightType::Log2Weight
    )
    return (i, j) -> max(log2(i + j), 1)
end

function hausdorff_map(
    range::Int,
    weightType::DistanceWeight = Log2Weight();
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    w = weight(range, weightType)

    sequence = total_order(range, order)

    M = zeros(Float64, range/2 + 1, range/2 + 1)
    for j in 0:Int(range/2)
        for i in 0:Int(range/2)
            path = cdr(i, j, [sequence])
            M[i + 1, j + 1] = hausdorff_distance(path) / w(i, j)
        end
    end
    return neighbors > 0 ? neighbors_map(M; d = neighbors) : M
end

function tracePlotType(
    plotType::SurfacePlot,
    z
    )
    trace = surface(z=z)
    layout = Layout(
        title = "Haussdorf distance surface map",
        autosize = false,
        width = 500,
        height = 500,
        margin = attr(l = 0, r = 0, b = 0, t = 65)
        )
    return trace, layout
end

function tracePlotType(
    plotType::HeatMapPlot,
    z
    )
    trace = heatmap(z=z)
    layout = Layout(
        title = "Haussdorf distance heat map",
        autosize = false,
        width = 500,
        height = 500,
        margin = attr(l = 0, r = 0, b = 0, t = 65)
        )
    return trace, layout
end

function hausdorff_plot(
    range::Int;
    weightType::DistanceWeight = Log2Weight(),
    plotType::PlotType = HeatMapPlot(),
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    M = hausdorff_map(range, weightType; order = order, neighbors = neighbors)
    z = [M[i, :] for i in 1:size(M, 1)]
    trace, layout = tracePlotType(plotType, z)
    plot(trace, layout)
end

function hausdorff_plot(
    M::Matrix;
    plotType::PlotType = HeatMapPlot(),
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    z = [M[i, :] for i in 1:size(M, 1)]
    trace, layout = tracePlotType(plotType, z)
    plot(trace, layout)
end

function hausdorff_describe(
    range::Int,
    weightType::DistanceWeight = Log2Weight();
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    #describe(hausdorff_map(range, weightType))
    describe_diag(hausdorff_map(range, weightType; order = order, neighbors = neighbors))
end
