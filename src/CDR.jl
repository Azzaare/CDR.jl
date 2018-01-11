__precompile__(true)
module CDR

using Plotly

export
TotalOrderAlgorithm, CorputSequence,
Dimension, Dim2, Dim3,
PlotType, SurfacePlot, HeatMapPlot,
DistanceWeight, NormalWeight, Log2Weight,
hausdorff_map, hausdorff_plot, hausdorff_describe

include("order.jl")
include("path.jl")
include("hausdorff.jl")

end # module
