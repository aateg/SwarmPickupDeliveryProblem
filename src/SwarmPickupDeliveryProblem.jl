module SwarmPickupDeliveryProblem

export main, checkDuplicates, checkOrdering

using Random: MersenneTwister, randperm
using StatsBase: sample
using VRPGeneticAlgorithm: Chromosome, Parameters, geneticAlgorithm

include("mPDP.jl")

function printSolution(solution::Chromosome, requestsWeights, problem::Problem)
    # for each vehicle I want to know the cities it visits
    # and compute the total distance
    println("\n")
    println(
        "Solution With Duplicates? ",
        checkDuplicates(solution.requests, solution.vehicles),
    )
    println("R:", solution.requests)
    println("Q:", [requestsWeights[i] for i in solution.requests])
    println("V:", solution.vehicles)
    cost = objFunction(solution.requests, solution.vehicles, problem)
    println("- Total Distance: ", 1 / cost)
    println("Cost: ", cost)
    println("Routes:")
    for vehicle = 1:problem.numberOfVehicles
        visits = solution.requests[solution.vehicles.==vehicle]
        println("- Vehicle $vehicle: ", [0; visits; 0])
    end
end

function checkDuplicates(R::Vector{Int64}, V::Vector{Int64})
    N = length(R)
    for i = 1:N
        for j = i+1:N
            if R[i] == R[j] && V[i] == V[j]
                return true
            end
        end
    end
    return false
end

function checkOrdering(R::Vector{Int64}, V::Vector{Int64}, Q::Vector{Int64})
    # this function assumed that there are (R_i, V_i) duplicates
    # then all vehicles associated with R_i are different
    N = length(R)
    maxNumberOfVehicles = 0 # maximum amount of vehicles needed for request
    vehiclesAllocated = Int64[] # vehicles allocated for each request
    for i = 1:N-1
        if Q[i] == 1
            if !(V[i] in vehiclesAllocated)
                continue
            else
                println("cannot send an allocated vehicle to another request")
                return false
            end
        else # Q[i] > 1
            if length(vehiclesAllocated) == 0
                # means that there are no vehicles allocated for the current request
                # set the max count to the number of vehicles needed for this request
                # add the vehicle to the list of allocated vehicles
                maxNumberOfVehicles = Q[i]
                push!(vehiclesAllocated, V[i])
            else
                if R[i-1] == R[i]
                    push!(vehiclesAllocated, V[i])
                else
                    println("cannot change from request until it is not finished")
                    return false
                end
                if length(vehiclesAllocated) == maxNumberOfVehicles
                    # we have allocated all the vehicles needed for this request
                    # reset the max count and the list of allocated vehicles
                    maxNumberOfVehicles = 0
                    vehiclesAllocated = Int64[]
                end
            end
        end
    end
    return true
end

isSolutionFeasible(solution::Chromosome, problem::Problem) = begin
    checkDuplicates(solution.requests, solution.vehicles) && checkOrdering(
        solution.requests,
        solution.vehicles,
        [problem.requestsWeights[i] for i in solution.requests],
    )
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

function solveMPDPHeavyObjects(nRequests::Int64, nVehicles::Int64, maxWeight::Int64)
    # Random Number Generator
    rng = MersenneTwister(1234)

    # Problem Definition
    problem = generateRandomHeavyObjectProblem(nRequests, nVehicles, maxWeight, rng)
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
        if isSolutionFeasible(solution, problem)
            return objFunction(solution.requests, solution.vehicles, problem)
        end
        return 1E-6
    end

    # Execution 
    generationParent = geneticAlgorithm(
        generationParent,
        fitnessFunction,
        parameters,
        rng,
        true,
        problem.requestsWeights,
    )

    # Output
    printSolution(generationParent[1], requestsWeights, problem)
end

end # module
