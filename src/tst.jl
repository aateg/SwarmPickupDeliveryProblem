module Tst

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
    random_seed = 1234
    rng = MersenneTwister(random_seed)
    X, Y, d = generate_distance_matrix(N, rng)    
    population_size = 10
    max_generations = 100

    # execution
    population = TSPGA.genetic_algorithm(N, d, population_size, max_generations, rng)
    println(population)

end

end # module