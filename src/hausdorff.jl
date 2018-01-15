abstract type PlotType end
struct SurfacePlot <: PlotType end
struct HeatMapPlot <: PlotType end

abstract type DistanceWeight end
struct NormalWeight <: DistanceWeight end
struct Log2Weight <: DistanceWeight end

abstract type Dimension end
struct Dim2 <: Dimension end
struct Dim3 <: Dimension end

function hausdorff_distance(
    path::Matrix{Int},
    dim::Dim2,
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


#path : dim x length
function hausdorff_distance(
    path::Matrix{Int},
    dim::Dim3
    )

    l = size(path,2)
    line = path[:, l] - path[:, 1]

    dist = 0

    for i in 2:(l - 1)

        proj_dist = (( path[1,i] - path[1,1]) * line[1] + (path[2,i]-path[2,1]) * line[2] + (path[3,i] - path[3,1]) * line[3] ) / norm(line)

        length = norm( path[:,i] - path[:,1] )
        proj_dist = min(proj_dist, length)

        d = sqrt(length^2 - proj_dist^2)
        dist = max(dist, d)
    end

    return dist

end


function weight(
    range::Int,
    weightType::NormalWeight,
    dim::Dim2
    )
    return (i, j) -> 1
end

function weight(
    range::Int,
    weightType::NormalWeight,
    dim::Dim3
    )
    return (i,j,k) -> 1
end

function weight(
    range::Int,
    weightType::Log2Weight,
    dim::Dim2
    )
    return (i, j) -> max(log2(i + j), 1)
end

function weight(
    range::Int,
    weightType::Log2Weight,
    dim::Dim3
    )
    return (i,j,k) -> max(log2(i+j+k), 1)
end

function hausdorff_map(
    range::Int,
    dim::Dimension = Dim2(),
    weightType::DistanceWeight = Log2Weight();
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    w = weight(range, weightType, dim)

    sequence = total_order(range, order)

    M = zeros(Float64, range/2 + 1, range/2 + 1)
    for j in 0:Int(range/2)
        for i in 0:Int(range/2)
            path = cdr(i, j, sequence)
            M[i + 1, j + 1] = hausdorff_distance(path, dim) / w(i, j)
        end
    end
    return neighbors > 0 ? neighbors_map(M; d = neighbors) : M
end

function hausdorff_map(
    range::Int,
    dim::Dim3,
    weightType::DistanceWeight = Log2Weight();
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    w = weight(range, weightType, dim)

    sequence = total_order(range, order)

    M = zeros(Float64, range + 1, range + 1)
    for i in 0:range
        for j in 0:range - i
            k = range - i -j
            path = cdr(i, j, k, sequence)
            M[i + 1, j + 1] = hausdorff_distance(path, dim) / w(i, j, k)
        end
    end
    return M
end


function tracePlotType(
    plotType::SurfacePlot,
    z
    )
    trace = surface(z=z)
    layout = Layout(
        title = "Hausdorff distance surface map",
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
        title = "Hausdorff distance heat map",
        autosize = false,
        width = 500,
        height = 500,
        margin = attr(l = 0, r = 0, b = 0, t = 65)
        )
    return trace, layout
end

function hausdorff_plot(
    range::Int;
    dim::Dimension = Dim2(),
    weightType::DistanceWeight = Log2Weight(),
    plotType::PlotType = HeatMapPlot(),
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    M = hausdorff_map(range, dim, weightType; order = order, neighbors = neighbors)
    z = [M[i, :] for i in 1:size(M, 1)]
    trace, layout = tracePlotType(plotType, z)
    plot(trace, layout)
end

function hausdorff_plot(
    range::Int,
    dim::Dim3,
    weightType::DistanceWeight = Log2Weight(),
    plotType::PlotType = HeatMapPlot(),
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    M = hausdorff_map(range, dim, weightType; order = order, neighbors = neighbors)
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
    dim::Dimension = Dim2(),
    weightType::DistanceWeight = Log2Weight();
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    #describe(hausdorff_map(range, weightType))
    describe_diag(hausdorff_map(range, dim, weightType; order = order, neighbors = neighbors))
end

function hausdorff_describe(
    range::Int,
    dim::Dim3,
    weightType::DistanceWeight = Log2Weight();
    order::TotalOrderAlgorithm = CorputSequence(),
    neighbors::Number = 0
    )
    #describe(hausdorff_map(range, weightType))
    describe(hausdorff_map(range, dim, weightType; order = order, neighbors = neighbors))
end
