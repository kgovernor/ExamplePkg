using Pkg

# Here are some useful packages...
dev_pkgs = [
    "PkgTemplates",
    "Documenter"
]

useful_packages = [
    "Distributions",
    "Random",
    "Statistics",
    "LinearAlgebra",
    "DataFrames",
    "DataFramesMeta",
    "CSV",
    "JuMP",
    "Ipopt",
    "Optim",
    "ForwardDiff",
    "Zygote",
    "Combinatorics",
    "StatsModels",
    "StatsBase",
    "ShiftedArrays",
    "ReadStat",
    "StatFiles",
    "LinearSolve"
]

# Add the packages
useful_packages = unique([ # Just in case I put the same pkg twice...
    dev_pkgs;

    ])
     
for pkg in useful_packages
    Pkg.add(pkg)
end