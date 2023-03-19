module SwarmPickupDeliveryProblem

include("GeneticAlgorithm/solution.jl")
include("GeneticAlgorithm/GeneticAlgorithm.jl")
include("Problems/Problems.jl")

using .GeneticAlgorithm: geneticAlgorithm, Parameters
using .Problems: PDP

using Random: MersenneTwister, randperm, AbstractRNG
using StatsBase: sample

function initializeGeneration(
    numberOfPickupDeliveries::Int64,
    numberOfVehicles::Int64,
    populationSize::Int64,
    rng::AbstractRNG,
)
    cchromo = randperm(rng, numberOfPickupDeliveries)
    vchromo = sample(rng, 1:numberOfVehicles, numberOfPickupDeliveries, replace=true)
    return collect(Solution(cchromo, vchromo) for i = 1:populationSize)
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

    # Redefine Objective function
    function objFunction(solution::Solution)
        return PDP.objFunction(solution.cchromosome, solution.vchromosome, problem)
    end

    # Initialization
    generationParent = initializeGeneration(
        problem.numberOfPickupDeliveries,
        problem.numberOfVehicles,
        parameters.populationSize,
        rng,
    )

    # Execution
    bestGeneration =
        geneticAlgorithm(generationParent, objFunction, parameters, rng)

    # Output
    bestSolution = bestGeneration[1]
    println("Best solution: ", bestSolution)
end

end # module