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

function summary(solution::Solution, problem::PDP.Problem)
    # for each vehicle I want to know the cities it visits
    # and compute the total distance
    println("Solution:")
    println("- Chromosome: ", solution.cchromosome)
    println("- Vehicles: ", solution.vchromosome)
    println(
        "- Total Distance: ",
        1 / PDP.objFunction(solution.cchromosome, solution.vchromosome, problem),
    )
    println("\n")
    println("Routes:")
    for vehicle = 1:problem.numberOfVehicles
        visits = solution.cchromosome[solution.vchromosome.==vehicle]
        cities = [0; [(problem.P[visit], problem.D[visit]) for visit in visits]; 0]
        println("- Vehicle $vehicle: ", cities)
    end
    println("\n")
end

function main()
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    numberOfPickupDeliveries = 10
    numberOfVehicles = 4
    problem = PDP.generateRandomMPDP(numberOfPickupDeliveries, numberOfVehicles, rng)
    PDP.summary(problem)
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
    summary(generationParent[1], problem)
    summary(generationParent[2], problem)

end
main()

end # module
