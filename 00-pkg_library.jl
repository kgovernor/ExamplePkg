using Pkg

# For developing packages
dev_pkgs = [
    "PkgTemplates", # See 01-create_pkg.jl
    "DocumenterTools", # See 02-create_documentation.jl
    "Documenter" # See 02-create_documentation.jl
]

# Interactive Notebooks
notebook_pkgs = [
    "Pluto", # Reactive programming environment. Like Jupyter Notebook but better
    "PlutoUI", # For adding interactivity to Julia, Pluto
    "IJulia", # For Jupyter Notebook
]

plots_pkgs = [
    "Plots", # To create graphs
    "PlotlyJS", # Interactive graphs
    "StatsPlots" # For more sophisticated plots
    ]

# Used often
essential_pkgs = [
    "LinearAlgebra", # For basic and advanced algebra operations e.g. finding determinant
    "Statistics", # Statistical package
    "Printf", # For making formatted strings
    "Random", # For generation random numbers
    "Distributions", # For generating data distributions e.g. Normal
    "Expectations", # For calculating E(f(x))
    "ProgressMeter", # Displays progress on runtime
    ]

# For working with data
data_pkgs = [
    "CSV", # To export to csv
    "RDatasets", # Load experimental datasets from R

    # DataFrame manipulation and Queries
    "DataFrames", # For creating and manipulating DataFrames
    "DataFramesMeta", # Helpful macros for manipulating DataFrames
    "Chain", # Helpful macros for implementing macros above
    "CategoricalArrays", # To initialize catagorical data
    "ShiftedArrays", # Useful for lagging and leading the dataset
    "Query", # To query data efficiently

    # Data Analysis
    "GLM", # Regressions
    "FixedEffectModels", # For fixed effects regressions
]

# For mathematical analysis
analysis_pkgs = [
    # Interval Arithmetic
    "IntervalArithmetic", # To do math on intervals

    # Integration and Interpolation
    "QuadGK", # Numerical Integration
    "FastGaussQuadrature", # Numerical Integration
    "Interpolations", # For interpolating data points
    "TaylorModels" # For Taylor Series Expansion

    # Differentiation and Root finding
    "ForwardDiff", # Numerical Differentiation
    "Zygote", # Numerical Differentiation
    "Roots", # Root finding packages
    "IntervalRootFinding", # Root finding using intervals

    # Solving Systems
    "LinearSolve", # Solve system of linear equations
    "NLSolve", # Solve system of non-linear equations

    # Optimization
    "JuMP", # Numerical Optimizer program
    "Ipopt", # Numerical Optimizer, use with JuMP
    "Optim", # Numerical Optimizer
    "BlackBoxOptim", # Numerical Optimizer, good for global Optimization
    "NLopt", # Numerical Optimizer, good for global Optimization, use with JuMP
] 

# For building neural networks
nn_pkgs = [
    "CUDA", # For GPU acceleration
    "Flux" # For building neural networks
]

# Combinatorics packages
combinatorics_pkgs = [
    "Combinatorics", # Useful for implementing permutations, combinations, etc.
]
     