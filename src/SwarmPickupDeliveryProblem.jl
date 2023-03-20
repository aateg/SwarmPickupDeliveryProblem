module SwarmPickupDeliveryProblem

using Random: MersenneTwister, randperm, AbstractRNG
using StatsBase: sample

include("GeneticAlgorithm.jl")
include("PDP.jl")

using .GeneticAlgorithm: geneticAlgorithm!, Parameters, Solution
import .PDP

function initializeGeneration(
    numberOfPickupDeliveries::Int64,
    numberOfVehicles::Int64,
    populationSize::Int64,
    rng::AbstractRNG,
)
    return collect(
        Solution(
            randperm(rng, numberOfPickupDeliveries), # cchromosome
            sample(rng, 1:numberOfVehicles, numberOfPickupDeliveries, replace = true), # vchromosome
        ) for i = 1:populationSize
    )
end



function main()
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    numberOfPickupDeliveries = 10
    numberOfVehicles = 4
    problem = PDP.generateRandomMPDP(numberOfPickupDeliveries, numberOfVehicles, rng)

    # Genetic Algorithm Parameters
    parameters = Parameters(10, 100, 0.8, 0.2)

    # Initialization
    generationParent = initializeGeneration(
        problem.numberOfPickupDeliveries,
        problem.numberOfVehicles,
        parameters.populationSize,
        rng,
    )

    # Redefine Objective function
    fitnessFunction(solution::Solution) =
        PDP.objFunction(solution.cchromosome, solution.vchromosome, problem)

    # Execution
    geneticAlgorithm!(generationParent, fitnessFunction, parameters, rng)

    # Output
    println("Best solution: ", generationParent[1])
    println("Second Best solution: ", generationParent[2])


end
main()

end # module
