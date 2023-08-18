###########################
# Generate Simulated Data #
###########################
include("checksimdata.jl")


"""
    DLWGMMIV.sim_data(N, T; <keyword arguments>)

Returns a `NamedTuple` containing a `DataFrame` of a panel dataset of `N` firms over `T+1` periods with specified parameters.

# Arguments
- `num_inputs::Integer=2`: the total number of production inputs to generate.
- `num_indp_inputs::Integer=1`: the number of independent inputs to generate.
- `input_names::Vector{String}`: a list of input names. Default is `["K","L"]. Additional inputs get a value of "X1","X2",... .
- `prod_params::Vector{Real}`: a list of parameters for the production function. Default is [0.1, 0.25]. Additional inputs get a value that is equal to 1 minus sum(prod_params) divided by the number of additional inputs, and TransLog second order terms get a value of 0.
- `cost_params::Vector{Real}`: a list of parameters for the cost function. Default is [0, 0.15]. Additional inputs get a value of 0.
- `omega_params::Vector{Real}`: a list of parameters for production technology function. Default is [0, 0.8, 0, 0].
- `seed::Integer`: sets a seed for `Random` number generator. Default is `-1`, no seed set.                                                                                                                    
```
"""
function sim_data(
    # arguments
    N, T; # N is number of firms, T is time periods
    # optional arguments
    num_inputs = 2, 
    num_indp_inputs = 1,  
    input_names = ["K", "L"], 
    prod_params = [0.1, 0.9], 
    cost_params = [0, 0.15], 
    omega_params = [0, 0.8, 0, 0], 
    indp_inputs_params = [1], 
    σ_ω = 1, 
    indp_inputs_lnmean = [0], 
    indp_inputs_lnvariance = [1], 
    seed = -1, 
    prodF = "CD", 
    costF = "ce", 
    rand_indp = true, 
    opt_error = 0.0
    )

    println("\n\nSim Data for $(num_inputs) inputs, $(prodF)")

    # Set seed for reproducibility
    if seed >= 0
        Random.seed!(seed)
    end
    
    # Check for errors
    check_options(num_inputs, num_indp_inputs, prodF, costF)

    # Generate input names
    input_names = gen_input_names(num_inputs, input_names)
    
    # Set up parameters
    prod_params, cost_params, omega_params, indp_inputs_params = gen_params(num_inputs, num_indp_inputs, input_names, prodF, prod_params, cost_params, omega_params, indp_inputs_params)

    # Functions to Generate Data ##
    S_func, TC_func = gen_prodF_costF(prodF, costF, prod_params, cost_params, num_inputs)

    # Initialize independent inputs, e.g. k, capital
    X = gen_indp_inputs(N, num_indp_inputs, indp_inputs_lnmean, indp_inputs_lnvariance)
    
    # Initialize dataframe
    firm_decision_df = DataFrame()
     
    # Initialize ω_it and TFP shock distribution
    ω_it = rand(Normal(0, σ_ω), N)
    TFP_shock_dist = Normal(0, σ_ω)
    ξ = zeros(N)
    TFP_shock = ξ

    # Initialize omega
    omega = ω_it

    for _ in 1:T
        # Add periodic TFP shock for each firm
        TFP_shock = rand(TFP_shock_dist, N)
        ω_it .= [ω_it.^0 ω_it ω_it.^2 ω_it.^3]*omega_params .+ TFP_shock
        omega = [omega; ω_it]
        # Update independent inputs
        indp = [X[i][(end-N)+1:end] for i in 1:num_indp_inputs]
        if rand_indp
            X =  [[X[i]; rand(LogNormal(indp_inputs_lnmean[i], indp_inputs_lnvariance[i]), N)] for i in 1:num_indp_inputs]
        else
            X = [[X[i]; indp[i].*(rand(LogNormal(indp_inputs_params[i], 0.2),N))] for i in 1:num_indp_inputs] 
        end      
        # Save ξ (TFP shock)
        ξ = [ξ; TFP_shock]
    end

    # Solve for dependent inputs
    Abar = prod(X[i].^prod_params[i] for i in 1:num_indp_inputs) .* prod((prod_params[j]/(1+cost_params[j]))^(prod_params[j]/(1+cost_params[j])) for j in (num_indp_inputs+1):num_inputs)
    αbar = sum(prod_params[j]/(1+cost_params[j]) for j in (num_indp_inputs+1):num_inputs)
    Ystar = (exp.(omega) .* Abar) .^ (1/(1-αbar))
    Xstar(αi, γi) = (αi .* Ystar ./ (1+γi)) .^ (1/(1+γi))
    for i in (num_indp_inputs+1):num_inputs
        push!(X, Xstar(prod_params[i],cost_params[i]))
    end

    # Add optimization error to labour
    X[num_indp_inputs+1] =  X[num_indp_inputs+1] .* rand(LogNormal(0, opt_error), length(X[1]))

    # Save results
    X_opt = (; zip(Symbol.(input_names), X)...)
    TC_opt = TC_func.(X...)
    S_opt = S_func.(X...)
    Y_opt = exp.(S_opt .+ omega)
    P_opt = Y_opt .- TC_opt

    C = []
    rent = []
    share_TC = []
    share_Y = []
    for i in 1:num_inputs
        input = [ i == j ? X[i] : zeros(length(TC_opt)) for j in 1:num_inputs]
        push!(C, TC_func.(input...))
        push!(rent, C[i]./X[i])
        push!(share_TC, C[i]./TC_opt)
        push!(share_Y, C[i]./Y_opt)
    end
    res = (; zip(Symbol.(["C_".*input_names; "rent_".*input_names; "share_TC_".*input_names; "share_Y_".*input_names]), [C; rent; share_TC; share_Y])...)

    # Save results to DataFrame
    firm_decision_df = DataFrame(time = repeat(0:T, inner = N), firm = repeat(1:N, outer = (T+1)), S = S_opt, Y = Y_opt, P = P_opt, TC = TC_opt, omega_i = omega, XI = ξ)
    firm_decision_df = hcat(firm_decision_df, DataFrame(X_opt))
    firm_decision_df = hcat(firm_decision_df, DataFrame(res))

    # Store parameters and functions
    params = (prod_params = prod_params, cost_params = cost_params, omega_params = omega_params, σ_ω = σ_ω, prodF = prodF) 
    funcs = (S_func = S_func, TC_func = TC_func)
    input_params = (input_names = input_names, num_inputs = num_inputs, num_indp_inputs = num_indp_inputs)

    # Summary
    vc = sim_data_validity_check(firm_decision_df, params, funcs, input_params)
    total_obs = nrow(firm_decision_df)
    println("\n=======================\n")
    println("SUMMARY:")
    println("\t$(round(100*count(vc.foc_pass)/total_obs, digits = 2))% of observations passed first order conditions.")
    println("\t$(round(100*count(vc.soc_pass)/total_obs, digits = 2))% of observations passed second order conditions.")
    println("\n=======================\n")
    
    return (df=firm_decision_df, params=params, funcs = funcs, input_params = input_params, derivative_check = vc)
end


### Helper Functions ###

function check_options(num_inputs, num_indp_inputs, prodF, costF)
    prodF_options = ["CD", "tl"]
    costF_options = ["ce"]
    if (num_inputs < 2) || (num_indp_inputs >= num_inputs) || (prodF ∉ prodF_options) || (costF ∉ costF_options)
        @error "Invalid arguments" # TO DO
        return
    end

    return prodF_options, costF_options
end

function gen_input_names(num_inputs, input_names)
    if length(input_names) < num_inputs
        for j in (length(input_names)+1):num_inputs
            input_names = [input_names; "X"*string(j)]
        end
    else
        input_names = input_names[begin:num_inputs]
    end

    return input_names
end

function gen_prodF_costF(prodF, costF, prod_params, cost_params, num_inputs)
    ### Production Functions
    funcs = []
    if prodF == "CD"
        # Cobb Douglas
        CobbDouglas(x...) = sum(log(x[i])*prod_params[i] for i in eachindex(x))
        funcs = [funcs; CobbDouglas]
    elseif prodF == "tl"
        # TransLog
        num_tl_terms = length(prod_params)
        TL_interactions(prod_params, x...) = sum([log(x[xcomb[1]])*log(x[xcomb[2]]) for xcomb in combinations(eachindex(x),2)][i]*prod_params[i] for i in eachindex(prod_params) )
        TransLog(x...) = sum(log(x[i])*prod_params[i] + (log(x[i])^2)*prod_params[(num_tl_terms-num_inputs+i)] for i in eachindex(x)) + TL_interactions(prod_params[(num_inputs+1):(num_tl_terms-num_inputs)], x...)
        funcs = [funcs; TransLog]
    end
 
    ### Cost Functions
    if costF == "ce"
        TC_1(x...) = sum(x[i]^(1+cost_params[i]) for i in eachindex(x))
        funcs = [funcs; TC_1]
    end

    return funcs
end

function gen_params(num_inputs, num_indp_inputs, input_names, prodF, prod_params, cost_params, omega_params, indp_inputs_params)
    vars = input_names
    num_prod_params = length(prod_params)
    num_cost_params = length(cost_params)
    num_omega_params = length(omega_params)
    num_indp_inputs_params = length(indp_inputs_params)
    
    sum_prod_params = sum(prod_params)
    prod_params = num_prod_params < num_inputs ? [prod_params; repeat([(1-sum_prod_params)/(num_inputs-num_prod_params)], (num_inputs-num_prod_params))] : prod_params
    cost_params = num_cost_params < num_inputs ? [cost_params; zeros(num_inputs-num_cost_params)] : cost_params[begin:num_inputs]
    if num_omega_params != 4  
        println("error!") # TO DO
    end
    indp_inputs_params = num_indp_inputs_params < num_indp_inputs ? [indp_inputs_params; ones(num_indp_inputs-num_indp_inputs_params)] : indp_inputs_params[begin:num_indp_inputs]

    num_prod_params = length(prod_params)
    if prodF == "CD"
        prod_params = prod_params[begin:num_inputs]
    elseif prodF == "tl"
        vars = [input_names; [join(xcomb) for xcomb in combinations(input_names,2)] ; input_names.*"2"] 
        num_tl_terms = num_inputs*2 + binomial(num_inputs,2) 
        prod_params = num_prod_params < num_tl_terms ? [prod_params; zeros(num_tl_terms-num_prod_params)] : prod_params[begin:num_tl_terms]
    end

    for i in eachindex(vars)
        println("\n$(vars[i]) Parameters:")
        print("  $(vars[i])_prod_params = $(prod_params[i]) | ")
        if i <=num_inputs
            print("$(vars[i])_cost_params = $(cost_params[i])")
        end
    end
    println("")
    
    return prod_params, cost_params, omega_params, indp_inputs_params
end

function gen_indp_inputs(num_samples, num_indp_inputs, indp_inputs_lnmean, indp_inputs_lnvariance)
    indp_inputs_lnmean = length(indp_inputs_lnmean) < num_indp_inputs ? [indp_inputs_lnmean; 5*ones(num_indp_inputs - length(indp_inputs_lnmean))] : indp_inputs_lnmean[begin:num_indp_inputs]
    indp_inputs_lnvariance = length(indp_inputs_lnvariance) < num_indp_inputs ? [indp_inputs_lnvariance; ones(num_indp_inputs - length(indp_inputs_lnvariance))] : indp_inputs_lnvariance[begin:num_indp_inputs]
    indp_inputs_distributions = MvLogNormal(indp_inputs_lnmean, diagm(indp_inputs_lnvariance))
    X_indp = rand(indp_inputs_distributions, num_samples)
    x_indp = [X_indp[i,:] for i in 1:num_indp_inputs]

    return x_indp
end

function gen_firm_decision(model, TC_func, input_names)
    X_indp = value.(model[:p][1:(end-1)]) 
    X = [X_indp; value.(model[:Xdep])]
    X_opt = (; zip(Symbol.(input_names), X)...)
    outcomes = ( Y = value(model[:Y]), S= value(model[:S]), P = value(model[:P]), TC = value(model[:TC]), omega_i = value(model[:p][end]), termination = string(termination_status(model)) ) 
    other_outcomes = other_firm_outcomes(TC_func, X, outcomes.TC, outcomes.Y, input_names)
    
    firm_decision = merge(X_opt, outcomes)
    for outcome in other_outcomes
        firm_decision = merge(firm_decision, outcome)
    end

    return firm_decision
end

function other_firm_outcomes(TC_func, X, TC, Y, input_names)
    input = zeros(length(X))
    C = []
    rent = []
    for i in eachindex(X)
        input[i] = X[i]
        C = [C; TC_func(input...)]
        rent = [rent; C[i]/X[i] ]
        input[i] = 0
    end
    share_TC = C ./ TC
    share_Y = C ./ Y

    C_res = (; zip(Symbol.("C_".*input_names), C)...)
    rent_res = (; zip(Symbol.("rent_".*input_names), rent)...)
    share_TC_res = (; zip(Symbol.("share_TC_".*input_names), share_TC)...)
    share_Y_res = (; zip(Symbol.("share_Y_".*input_names), share_Y)...)

    return C_res, rent_res, share_TC_res, share_Y_res
end
