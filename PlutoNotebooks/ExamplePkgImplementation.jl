### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ cf20552e-16a4-4514-be38-573de17edae9
begin
	import Pkg; Pkg.add(url="https://github.com/kgovernor/ExamplePkg.git")
end

# ╔═╡ 567c8a60-3d29-11ee-3900-6db745668a49
begin
	using ExamplePkg, PlutoUI, StatsPlots
end

# ╔═╡ 5fd52b50-4027-40bf-948a-d8b419adea98
md"# Implement our Package, ExamplePkg"

# ╔═╡ f28e00fa-bf27-4f2f-a17d-b6fcd1443da7
begin
	Ntrain, Ntest, T = 1000, 10, 0;
	train_pp = [0.4,0.6];
	dev = 0.05;
	test_pp = train_pp .+ [dev,-dev];
end

# ╔═╡ 30845dd5-4501-45cc-bbc6-e678f9615bd1
mc = monopsony_classifier(Ntrain, Ntest, train_pp, test_pp);

# ╔═╡ c65c9675-6a23-4e14-a13e-2569ba787f0c
plot(1:length(mc.losses), mc.losses, title="loss function", ylabel="losses", xlabel = "epochs", legend=false)

# ╔═╡ 52b75de9-f5d6-45d9-848b-4522e817e173
groupedbar(
	[mc.ytest[1,1,:] mc.mod(mc.xtest)[1,1,:]], 
	bar_position = :dodge, 
	title = "Test Data Results", 
	xlabel = "firms", ylabel = "probability monopsonistic", 
	label=["actual" "predicted"], legend=:outerbottom, legendcolumns=2
)

# ╔═╡ c8c59758-786f-4bd2-9341-126e425e98d8
md"""
## Let's Test our NN out on different wage and production parameter specs!
deviation:
$(@bind deviation Slider(-0.4:0.1:0.4, default = 0))

w_μ:
$(@bind wμ Slider(-1:0.2:1, default = 0))

w_σ:
$(@bind wσ Slider(0:0.2:5, default = 1))
"""

# ╔═╡ d872d99c-6389-494e-ad5e-97076232d421
begin
	pp = [0.5,0.5] .+ [deviation,-deviation];
	(pp = pp, wμ = wμ, wσ = wσ)
end

# ╔═╡ f9178417-0013-41ca-b04d-b5605d68bd67
y, x = nn_data(Ntest, T, pp, wμ, wσ);

# ╔═╡ 34556f05-7380-43c5-914d-9cb5af4ef26a
groupedbar(
	[y[1,1,:] mc.mod(x)[1,1,:]], 
	bar_position = :dodge,
	title = "Simmed Data Results",
	xlabel = "firms", ylabel = "probability monopsonistic", 
	label=["actual" "predicted"], legend=:outerbottom, legendcolumns=2
)

# ╔═╡ Cell order:
# ╠═5fd52b50-4027-40bf-948a-d8b419adea98
# ╠═cf20552e-16a4-4514-be38-573de17edae9
# ╠═567c8a60-3d29-11ee-3900-6db745668a49
# ╠═f28e00fa-bf27-4f2f-a17d-b6fcd1443da7
# ╠═30845dd5-4501-45cc-bbc6-e678f9615bd1
# ╠═c65c9675-6a23-4e14-a13e-2569ba787f0c
# ╠═52b75de9-f5d6-45d9-848b-4522e817e173
# ╠═c8c59758-786f-4bd2-9341-126e425e98d8
# ╠═d872d99c-6389-494e-ad5e-97076232d421
# ╠═f9178417-0013-41ca-b04d-b5605d68bd67
# ╠═34556f05-7380-43c5-914d-9cb5af4ef26a
