using JuMP
using DelimitedFiles
using Random
using Plots

function generate_data_model(n; random_seed=42)
    N = 2n + 2
    N_1 = 2n + 1
    rng = Random.MersenneTwister(random_seed)
    X = 100 * rand(rng, N)
    Y = 100 * rand(rng, N)
    c = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:N, j in 1:N]
    
    PandD = Random.shuffle(rng, 1:N_1)
    P = []
    D = []
    for i in 1:n
        push!(P, PandD[i])
        push!(D, PandD[(i+n)])
    end
    
    return X, Y, c, P, D
end

function get_solution()
    Dict(i => j for i in V for j in V if JuMP.value(x[i, j]) != 0)
end

function solution_with_subtours(solution)
    previous = 1 # first depot 
    last_depot = 2n + 2
    
    while true
        @show previous
        subtour = [previous]
        next = solution[previous]
        
        if next == previous
            return true
        end
        
        push!(subtour, next)
        if next == last_depot
            return size(subtour) != (2n + 2)
        end
        
        previous = next
        
    end
end

function show_pickup_delivery(P, D)
    for (i, j) in zip(P,D)
        @show i, j
    end
end

function read_data()
    pathDistanceMatrix = joinpath(@__DIR__, "data", "distanceMatrix.txt")
    pathPickups = joinpath(@__DIR__, "data", "pickups.txt")
    pathDeliveries = joinpath(@__DIR__, "data", "deliveries.txt")

    C = readdlm(open(pathDistanceMatrix), ' ', Int, '\n')
    P = readdlm(open(pathPickups), ' ', Int, '\n')
    D = readdlm(open(pathDeliveries), ' ', Int, '\n')
    n = size(P)[2]
    return C, P[1,:], D[1,:], n

end

function plot_tour(X, Y, x)
    plot = Plots.plot()
    for (i, j) in selected_edges(x, size(x, 1))
        Plots.plot!([X[i], X[j]], [Y[i], Y[j]]; legend = false)
    end
    return plot
end

plot_tour(X, Y, value.(iterative_model[:x]))