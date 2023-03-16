module SwarmPickupDeliveryProblem

using Random: MersenneTwister

include("GeneticAlgorithm/GeneticAlgorithm.jl")
using .GeneticAlgorithm: geneticAlgorithm, Config

include("Problems/Problems.jl")
using .Problems: TSP, PDP, Utils

function main()
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    numberOfPickupDeliveries = 10
    problem = generateRandomPDP(numberOfPickupDeliveries, rng)
    
    # Genetic Algorithm Parameters
    parameters = Config(10, 100, 0.8, 0.2)

    # execution
    bestGeneration = geneticAlgorithm(
        problem.encoding,
        problem.objFunction, 
        parameters, 
        rng
    )

    # output
    bestSolution = bestGeneration[1]
    println("Best solution: ", bestSolution)

end

end # module
