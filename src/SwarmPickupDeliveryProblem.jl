module SwarmPickupDeliveryProblem

export main

using Random: MersenneTwister, randperm
using StatsBase: sample
using VRPGeneticAlgorithm: Chromosome, Parameters, geneticAlgorithm

include("mPDP.jl")

function printSolution(solution::Chromosome, requestsWeights, problem::Problem)
    # for each vehicle I want to know the cities it visits
    # and compute the total distance
    println("\n")
    println("Solution With Duplicates? ", checkDuplicates(solution))
    println("Weights per Request", requestsWeights)
    cost = objFunction(solution.requests, solution.vehicles, problem)
    println("- Total Distance: ", 1 / cost)
    println("Cost: ", cost)
    println("Routes:")
    for vehicle = 1:problem.numberOfVehicles
        visits = solution.requests[solution.vehicles.==vehicle]
        println("- Vehicle $vehicle: ", [0; visits; 0])
    end
end

function checkDuplicates(solution)
    N = length(solution.requests)
    for i = 1:N
        for j = i+1:N
            if solution.requests[i] == solution.requests[j] &&
               solution.vehicles[i] == solution.vehicles[j]
                return true
            end
        end
    end
    return false
end

function initializeGenerationHeavyObjects(
    requestsWeights::Vector{Int64},
    numberOfVehicles::Int64,
    populationSize::Int64,
    rng::AbstractRNG,
)
    requests = [r for r = 1:length(requestsWeights) for _ = 1:requestsWeights[r]]
    N = length(requests)
    return collect(
        Chromosome(
            shuffle(rng, requests), # requests
            sample(rng, 1:numberOfVehicles, N, replace = true), # vehicles
        ) for i = 1:populationSize
    )
end

function solveMPDPHeavyObjects(nRequests::Int64, nVehicles::Int64)
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    problem = generateRandomMPDP(nRequests, nVehicles, rng)
    maxWeight = 2
    requestsWeights = Vector{Int64}(undef, nRequests)
    for i = 1:nRequests
        requestsWeights[i] = rand(rng, 1:maxWeight)
    end
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
                if solution.requests[i] == solution.requests[j] &&
                   solution.vehicles[i] == solution.vehicles[j]
                    return 1E-6
                end
            end
        end
        return objFunction(solution.requests, solution.vehicles, problem)
    end

    # Execution
    generationParent = geneticAlgorithm(
        generationParent,
        fitnessFunction,
        parameters,
        rng,
        true,
        requestsWeights,
    )

    # Output
    printSolution(generationParent[1], requestsWeights, problem)

end
solveMPDPHeavyObjects(10, 3)

end # module
