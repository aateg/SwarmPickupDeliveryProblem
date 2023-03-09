module SwarmPickupDeliveryProblem

using Random: MersenneTwister, AbstractRNG

include("TSPGA/TSPGA.jl")
import .TSPGA

function generate_distance_matrix(N::Int, rng::AbstractRNG)
    X = 100 * rand(rng, N)
    Y = 100 * rand(rng, N)
    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:N, j in 1:N]
    return X, Y, d
end

function main()

    # configuration
    N = 10 # chromosome length
    rng = MersenneTwister(1234)
    X, Y, d = generate_distance_matrix(N, rng)    
    population_size = 10
    max_generations = 100

    # execution
    best_generation = TSPGA.genetic_algorithm(N, d, population_size, max_generations, rng)

    # output
    best_solution = best_generation[1]

    println("Best solution: ", best_solution)

end

end # module
