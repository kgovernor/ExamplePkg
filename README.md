# Julia Orientation Example Package

Here is the Julia Orientation 2023 example package.

In it you will find:

- A package library
- How to create a package
- How to create documentation
- Pluto Notebooks for examples of implementation of this package and other useful Julia examples
- An example package, simulates firm data and analyzes firm labor monopsony power using a NN

## ExamplePkg.jl

This package simulates panel firm data of N firms over T time periods and analyzes firm labor monopsony power using a neural network. Recall that under perfect competition, firms will set the marginal product of labor to be equal to the real wage rate. If the real wage rate is below the marginal product of labor, then the firm is displaying some level of labor monopsony power. A neural network is developed to classify whether or not the firm has labor monopsony power, i.e., if firms are paying a real wage rate below the marginal product of labor. 

## Helpful Links

### QuantEcon - Overall Source for Julia Economics
[QuantEcon Julia](https://julia.quantecon.org/intro.html) is generally useful for certain types of problems, however, it takes some time to navigate the material.

### Setting up Julia
[Install](https://julialang.org/downloads/)

#### VS Code
[Video](https://www.youtube.com/watch?v=lO2vxgrcKd4) <br>
[Tutorial](https://www.julia-vscode.org/docs/dev/gettingstarted/)

#### Jupyter
[Video](https://www.youtube.com/watch?v=81DRruCIO34)

#### Pluto
[Pluto - a reactive programming environment](https://plutojl.org/)

### Create Package
[Video](https://www.youtube.com/watch?v=QVmU29rCjaA) <br>
[PkgTemplates.jl](https://juliaci.github.io/PkgTemplates.jl/stable/user/) <br>
[Alternative Tutorial](https://blog.jcharistech.com/2021/09/27/how-to-develop-and-publish-julia-packages-for-beginners/)

### Documentation
[Video](https://www.youtube.com/watch?v=e8RY83erZFs) <br>
[DocumenterTools.jl](https://documenter.juliadocs.org/stable/lib/public/#DocumenterTools.generate) initializes the folder template for documentation <br>
[Documenter.jl](https://documenter.juliadocs.org/stable/man/guide/). Heads up, can take a bit of troubleshooting to get the Documentation onto GitHub-Pages. Unfortunately, I forgot how I troubleshooted this, but I recall using keys generated from DocumenterTools and adding to the git settings... You'd need to go through the Documenter.jl package thoroughly and watch the video. <br>
[Docstrings](https://www.youtube.com/watch?v=m3c8Z6HBn48). Also see Documenter.jl.

### Data Frame Manipulation
[DataFrames.jl](https://dataframes.juliadata.org/stable/man/querying_frameworks/) <br>
[Lagging DataFrames in Julia using ShiftedArrays.jl](https://bkamins.github.io/julialang/2022/09/23/lagging.html)

### Optimizing Performance in Julia
[Julia Performance Tips](https://docs.julialang.org/en/v1/manual/performance-tips/) <br>
[Optimizing Code: A practical guide](https://viralinstruction.com/posts/optimise/#cut_down_on_allocations) <br>
[More Performance Tips](https://www.juliafordatascience.com/performance-tips/) <br>
[Unleashing Code Potential](https://marketsplash.com/tutorials/julia/julia-performance/#google_vignette)