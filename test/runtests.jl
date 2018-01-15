using CDR
using Base.Test

#Pkg.test("CDR")

# TODO: write basic tests

# hausdorff_describe(10)
# hausdorff_describe(50)
# hausdorff_describe(100)
# hausdorff_describe(500)
# hausdorff_describe(1000)
#hausdorff_describe(5000)

hausdorff_describe(10; order = RandomSequence())
hausdorff_describe(50; order = RandomSequence())
hausdorff_describe(100; order = RandomSequence())
hausdorff_describe(500; order = RandomSequence())
hausdorff_describe(1000; order = RandomSequence())
