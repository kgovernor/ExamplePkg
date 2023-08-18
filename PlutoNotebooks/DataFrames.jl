### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 72a128f6-6a99-496c-b69a-82b76540e44f
begin
	import Pkg; Pkg.add(url="https://github.com/kgovernor/ExamplePkg.git")
end

# ╔═╡ d8daeb69-accb-4366-868c-c3dfab29f27a
using DataFrames, DataFramesMeta, ExamplePkg, ShiftedArrays, Statistics

# ╔═╡ 92e03b50-3d79-11ee-1c49-55ce30cc8467
md"""
# Dataframes
"""

# ╔═╡ 0ae1e347-c3d2-4bcd-9aba-52ebc97da7ab
md"""
## Simulate a dataframe from ExamplePkg
"""

# ╔═╡ 8c015efc-1217-414a-8cf6-c44d926e2375
begin
	N, T = 10, 3; # N number of firms, T number of time periods
	df = ExamplePkg.sim_data(N,T).df;
end

# ╔═╡ c53fe6a8-3483-418e-9a47-f5d27c0feb32
md"""
## Manipulate Dataframe

$(
@chain df begin
    @transform(:l = log.(:L)) # create new variable
	@subset(:time .> 0) # take subset of df
    @by(:time, :meanK = mean(:K), :meanL = mean(:L), :num_firms = length(:firm)) # generate group statistics
    @orderby(:time) # Sort data
    @select(:year = :time, :meanK, :meanL, :num_firms) # return dataset of selected variables
end
)
"""

# ╔═╡ 705ab7a8-8e43-4388-b097-26ba180cc4d7
md"""
### Here is how to lag
$(
transform(groupby(df, :firm), :L => ShiftedArrays.lag)
)   
"""

# ╔═╡ bb89023e-939a-4b1c-91d3-03b173943f9a
md"""
### Here is how to lead
$(
sort(transform(groupby(df, :firm), :L => ShiftedArrays.lead), :firm)
) 
"""

# ╔═╡ Cell order:
# ╠═92e03b50-3d79-11ee-1c49-55ce30cc8467
# ╠═72a128f6-6a99-496c-b69a-82b76540e44f
# ╠═d8daeb69-accb-4366-868c-c3dfab29f27a
# ╠═0ae1e347-c3d2-4bcd-9aba-52ebc97da7ab
# ╠═8c015efc-1217-414a-8cf6-c44d926e2375
# ╠═c53fe6a8-3483-418e-9a47-f5d27c0feb32
# ╠═705ab7a8-8e43-4388-b097-26ba180cc4d7
# ╠═bb89023e-939a-4b1c-91d3-03b173943f9a
