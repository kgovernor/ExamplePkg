# Neural network for classifying monopsonistic power in labour market
function monopsony_classifier(
    Ntrain, Ntest, train_pp, test_pp; 
    T=0,
    wtrain_μ = 0,
    wtrain_σ = 1,
    wtest_μ = 0,
    wtest_σ = 1,
    marg_err_p = 0.01,
    epochs = 1000
    )

    # Sim data for training
    ytrain, xtrain = nn_data(Ntrain, T, train_pp, wtrain_μ, wtrain_σ, marg_err_p=marg_err_p)
    println("---Training data complete\n")

    # Sim data for testing
    ytest, xtest = nn_data(Ntest, T, test_pp, wtest_μ, wtest_σ, marg_err_p=marg_err_p)
    println("---Test data complete\n")

    # Build network
    dim_input = 4
    dim_output = 1
    Q1 = 30;
    Q2 = 18;

    # 3 layer network
    dense_3L(in, L1, L2, out) = Chain(Dense(in => L1), Dense(L1 => L2, σ), Dense(L2 => out, σ))
    model = dense_3L(dim_input, Q1, Q2, dim_output)

    # Loss function - binary crossentropy
    loss(model, x, y) = Flux.logitbinarycrossentropy(model(x), y)
    println("Model 1: initial loss: ", loss(model, xtrain, ytrain))

    # Training
    println("---Starting training\n")
    opt = Descent(0.2) # learning style of gradient descent and learning rate of 0.2
    data = [(xtrain, ytrain)]
    Flux.train!(loss, model, data, opt) # train model

    println("Model 1: 1st loss: ", loss(model, xtrain, ytrain))

    losses = []
    for epoch in 1:epochs # train model each epoch unless threshold is achieved
        training = false
        l1 = loss(model, xtrain, ytrain)
        if abs(losses[-1] - l1) >= 1e-8 # keep training if change in loss is at least 1e-8 
            Flux.train!(loss, model, data, opt) 
            push!(losses, l1)
            training = true
        end
        if !training
            break
        end
    end

    println("Model 1: final loss: ", losses[end])


    println("\nModel 1: Test...")
    println("prediction: ", model(xtest))
    println("\nactual: ", ytest)

    println()
    perf1= loss(model, xtest, ytest)
    println("Performance:\n\t Model 1 - ", perf1)

    return (mod = model, ytest = ytest, xtest = xtest, losses = losses) # return model, test data, and losses
    
end

# Create data for nn
function nn_data(N, T, pp, w_μ, w_σ; marg_err_p=0.01)
    df = sim_data(N, T, prod_params=pp).df # based on Cobb-Douglas production function

    y = zeros(1, T+1, N) # output - batch size T+1
    x = zeros(4, T+1, N) # inputs - batch size T+1
    for i in 1:N
        K = df[df.firm .== i, :].K # capital input
        L = df[df.firm .== i, :].L # labor input
        Y = df[df.firm .== i, :].Y # production output input

        x[1,:,i] = log.(K) # log capital
        x[2,:,i] = log.(L) # log labor
        x[3,:,i] = log.(Y) # log production output

        # Sim wages for test
        marg_L = log.(pp[2] .* (Y ./ L)) # log of marginal product of labor for Cobb-Douglas production function 
        x[4,:,i] = rand.(Normal.(marg_L .+ w_μ, w_σ)) # simulated wages 
        y[:,:,i] = marg_L .> (x[4,:,i] .* (1+marg_err_p)) # binary output of monopsony power
    end

    return y, x
end