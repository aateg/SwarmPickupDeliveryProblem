module SwarmPickupDeliveryProblem

include("GeneticAlgorithm/GeneticAlgorithm.jl")
import .GeneticAlgorithm: geneticAlgorithm, Config

include("Problems/Problems.jl")
import .Problems: generateRandomPDP, generateRandomTSP

function main()
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    numberOfPickupDeliveries = 10
    problem = generateRandomPDP(numberOfPickupDeliveries, rng)
    
    # Genetic Algorithm Parameters
    parameters = Config(
        populationSize = 10, 
        maxGenerations = 100, 
        pCross = 0.8, 
        pMutate = 0.2
    )

    # execution
    bestGeneration = geneticAlgorithm(
        problem, 
        parameters, 
        rng
    )

    # output
    best_solution = best_generation[1]
    println("Best solution: ", best_solution)

end

end # module
