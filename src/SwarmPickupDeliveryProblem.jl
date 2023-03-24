module SwarmPickupDeliveryProblem

export main

using Random: MersenneTwister, randperm
using StatsBase: sample
using VRPGeneticAlgorithm: Chromosome, Parameters, geneticAlgorithm

include("pickupDeliveryProblem.jl")

function initializeGeneration(
    numberOfPickupDeliveries::Int64,
    numberOfVehicles::Int64,
    populationSize::Int64,
    rng::AbstractRNG,
)
    return collect(
        Chromosome(
            randperm(rng, numberOfPickupDeliveries), # requests
            sample(rng, 1:numberOfVehicles, numberOfPickupDeliveries, replace = true), # vehicles
        ) for i = 1:populationSize
    )
end

function printSolution(solution::Chromosome, problem::Problem)
    # for each vehicle I want to know the cities it visits
    # and compute the total distance
    println("\n")
    println("Chromosome:")
    println("- Chromosome: ", solution.requests)
    println("- Vehicles: ", solution.vehicles)
    cost = objFunction(solution.requests, solution.vehicles, problem)
    println("- Total Distance: ", 1 / cost)
    println("Cost: ", cost)
    println("Routes:")
    for vehicle = 1:problem.numberOfVehicles
        visits = solution.requests[solution.vehicles.==vehicle]
        s = Int64[]
        push!(s, 0)
        for visit in visits
            push!(s, problem.P[visit])
            push!(s, problem.D[visit])
        end
        push!(s, 0)
        println("- Vehicle $vehicle: ", s)
    end
end

function main()
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    numberOfPickupDeliveries = 10
    numberOfVehicles = 4
    problem = generateRandomMPDP(numberOfPickupDeliveries, numberOfVehicles, rng)
    printProblem(problem)

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
    fitnessFunction(solution::Chromosome) =
        objFunction(solution.requests, solution.vehicles, problem)

    # Execution
    generationParent = geneticAlgorithm(generationParent, fitnessFunction, parameters, false, rng)

    # Output
    printSolution(generationParent[1], problem)
    printSolution(generationParent[end], problem)

end

end # module
