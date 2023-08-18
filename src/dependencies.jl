### Installation of dependencies to ExamplePkg
using Pkg

Pkg.activate(".") # Activate the package environment

dependencies= [
    "Distributions",
    "Random",
    "Statistics",
    "LinearAlgebra",
    "DataFrames",
    "CSV",
    "ForwardDiff",
    "Zygote",
    "StatsModels",
    "StatsBase",
    "ShiftedArrays",
    "ReadStat",
    "StatFiles",
    "LinearSolve",
    "Flux",
    "CUDA"
]

dependencies = unique([dependencies]) # Just in case I have duplicate entries
for dep in dependencies
    Pkg.add(dep)#, preserve=Pkg.PRESERVE_DIRECT) # To preserve the version of the dependency installed when updates are made to this package
end

