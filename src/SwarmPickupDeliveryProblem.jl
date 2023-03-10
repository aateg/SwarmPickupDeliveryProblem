module SwarmPickupDeliveryProblem

include("TSPGA/TSPGA.jl")
import .TSPGA

include("PDP/PDP.jl")
import .PDP

function main()
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    numberOfPickupDeliveries = 10
    problem = PDP.generateRandomPickupDeliveryProblem(numberOfPickupDeliveries, rng)
    
    # Genetic Algorithm Parameters
    p_cross = 0.8
    p_mut = 0.2
    population_size = 10
    max_generations = 100

    # execution
    best_generation = TSPGA.genetic_algorithm(
        problem.encoding, 
        problem.obj_function, 
        population_size, 
        max_generations, 
        problemTSP.rng
    )

    # output
    best_solution = best_generation[1]

    println("Best solution: ", best_solution)

end

end # module
