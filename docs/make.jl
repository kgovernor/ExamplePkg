using Documenter, ExamplePkg

makedocs(
    sitename = "ExamplePkg",
    format = Documenter.HTML(),
    modules = [ExamplePkg],
    pages = [
        "Home" => "index.md",
        "New Page" => "newpage.md",
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/kgovernor/ExamplePkg.jl"
)
