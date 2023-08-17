using ExamplePkg
using Test

@testset "ExamplePkg.jl" begin
    # Write your tests here.
    Ntrain, Ntest, T = 1000, 10, 0
    train_pp = [0.4,0.6]
    dev = 0.05
    test_pp = train_pp .+ [dev,-dev]

    ### Testing sim_data ###
    println("\n\n-----TESTING SIM DATA FUNCTION-----\n")
    @time res = ExamplePkg.sim_data(Ntest, T, prod_params = train_pp)
    display(res.df)
    println("\n==========================================")

    ### Testing monopsony_classifier ###
    println("\n\n-----TESTING NN FUNCTION-----\n")
    @time mc = monopsony_classifier(Ntrain, Ntest, train_pp, test_pp)

    println("\n==========================================")

end
