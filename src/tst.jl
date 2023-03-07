module Tst

using Random: MersenneTwister

include("TSP_GA.jl")
import .TSPGA

function main()

    # configuration
    N = 10 # chromosome length
    random_seed = 1234
    rng = MersenneTwister(random_seed)
    X, Y, d = TSPGA.generate_distance_matrix(N, rng)    
    population_size = 10
    max_generations = 100

    # execution
    population = TSPGA.genetic_algorithm(N, d, population_size, max_generations, rng)
    println(population)

end

end # module