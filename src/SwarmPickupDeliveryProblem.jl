module SwarmPickupDeliveryProblem

export main

using Random: MersenneTwister, randperm
using StatsBase: sample
using VRPGeneticAlgorithm: Chromosome, Parameters, geneticAlgorithm

include("mPDP.jl")

function initializeGenerationMPDP(
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

function initializeGenerationHeavyObjects(
    requestsWeights::Dict{Int64, Int64},
    numberOfVehicles::Int64,
    populationSize::Int64,
    rng::AbstractRNG,
)
    requests = [request for (request, weights) in requestsWeights for _ in 1:weights]
    N = length(requests)
    return collect(
        Chromosome(
            shuffle(rng, requests), # requests
            sample(rng, 1:numberOfVehicles, N, replace = true), # vehicles
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

function solveMPDP(nRequests::Int64, nVehicles::Int64)
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    problem = generateRandomMPDP(nRequests, nVehicles, rng)
    printProblem(problem)

    # Genetic Algorithm Parameters
    parameters = Parameters(10, 100, 0.8, 0.2)

    # Initialization
    generationParent = initializeGenerationMPDP(
        problem.numberOfPickupDeliveries,
        problem.numberOfVehicles,
        parameters.populationSize,
        rng,
    )

    # Redefine Objective function
    fitnessFunction(solution::Chromosome) =
        objFunction(solution.requests, solution.vehicles, problem)

    # Execution
    generationParent =
        geneticAlgorithm(generationParent, fitnessFunction, parameters, false, rng)

    # Output
    printSolution(generationParent[1], problem)
    printSolution(generationParent[end], problem)
end

function solveMPDPHeavyObjects(nRequests::Int64, nVehicles::Int64)
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    problem = generateRandomMPDP(nRequests, nVehicles, rng)
    requestsWeights = Dict{Int64, Int64}(i => rand(rng, 1:3) for i in 1:problem.numberOfPickupDeliveries)
    printProblem(problem)

    # Genetic Algorithm Parameters
    parameters = Parameters(10, 100, 0.8, 0.2)

    # Initialization
    generationParent = initializeGenerationHeavyObjects(
        requestsWeights,
        problem.numberOfVehicles,
        parameters.populationSize,
        rng,
    )

    # Redefine Objective function
    fitnessFunction(solution::Chromosome) = begin
        # if solution contain pair (request[i], vehicle[i]) duplicated then cost is zero
        for i = 1:length(solution.requests)
            for j = i+1:length(solution.requests)
                if solution.requests[i] == solution.requests[j] && solution.vehicles[i] == solution.vehicles[j]
                    return 1E-6
                end
            end
        end
        return objFunction(solution.requests, solution.vehicles, problem)
    end

    # Execution
    generationParent =
        geneticAlgorithm(generationParent, fitnessFunction, parameters, true, rng)

    # Output
    printSolution(generationParent[1], problem)
    printSolution(generationParent[end], problem)

end
solveMPDPHeavyObjects(10,3)

end # module
