using CDR
using Base.Test

#Pkg.test("CDR")

# TODO: write basic tests

hausdorff_describe(10, neighbors = 2)
hausdorff_describe(10, neighbors = 1)
hausdorff_describe(10)

dim = Dim3()
CDR.describe(CDR.hausdorff_map(16, Dim3(),  NormalWeight()))
CDR.describe(CDR.hausdorff_map(32, Dim3(), NormalWeight()))
CDR.describe(CDR.hausdorff_map(64, Dim3(), NormalWeight()))

CDR.describe(CDR.hausdorff_map(16, Dim3()  ))
CDR.describe(CDR.hausdorff_map(32, Dim3() ))
CDR.describe(CDR.hausdorff_map(64, Dim3()))

hausdorff_describe(16, dim)
hausdorff_describe(32, dim)
hausdorff_describe(64, dim)

sequence = CDR.total_order(8, CorputSequence())
path = CDR.cdr(2,2,4, sequence)

println(sequence)

for i = 1:9
  println(path[:,i])
end

println(CDR.hausdorff_distance(path, Dim3()) )

w = CDR.weight(8, Log2Weight(), Dim3())

println(w(2,2,4) )

println( CDR.hausdorff_map(4, Dim3()) )
CDR.describe(CDR.hausdorff_map(4, Dim3()))

# hausdorff_describe(50)
# hausdorff_describe(100)
# hausdorff_describe(500)
# hausdorff_describe(1000)
#hausdorff_describe(5000)

# hausdorff_describe(10; order = RandomSequence())
# hausdorff_describe(50; order = RandomSequence())
# hausdorff_describe(100; order = RandomSequence())
# hausdorff_describe(500; order = RandomSequence())
# hausdorff_describe(1000; order = RandomSequence())
