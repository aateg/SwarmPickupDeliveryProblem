module SwarmPickupDeliveryProblem

include("GeneticAlgorithm/GeneticAlgorithm.jl")
import .GeneticAlgorithm: genetic_algorithm, GAConfig

include("Problems/Problems.jl")
import .Problems: generateRandomPickupDeliveryProblem, generateRandomTSP

function main()
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    numberOfPickupDeliveries = 10
    problem = generateRandomPickupDeliveryProblem(numberOfPickupDeliveries, rng)
    
    # Genetic Algorithm Parameters
    parameters = GAConfig(
        population_size = 10, 
        max_generations = 100, 
        p_cross = 0.8, 
        p_mutate = 0.2
    )

    # execution
    best_generation = TSPGA.genetic_algorithm(
        problem.encoding, 
        problem.obj_function, 
        parameters, 
        rng
    )

    # output
    best_solution = best_generation[1]

    println("Best solution: ", best_solution)

end

end # module
