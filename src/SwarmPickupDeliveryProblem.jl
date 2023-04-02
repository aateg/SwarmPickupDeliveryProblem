module SwarmPickupDeliveryProblem

export solveMPDPHeavyObjects, solutionContainsDuplicates, solutionCorrectlyOrdered

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
        solutionContainsDuplicates(solution.requests, solution.vehicles),
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

function solutionFeasible(solution::Chromosome, problem::Problem)
    solutionWithDuplicates =
        solutionContainsDuplicates(solution.requests, solution.vehicles)
    realizable = solutionCorrectlyOrdered(
        solution.requests,
        solution.vehicles,
        [problem.requestsWeights[i] for i in solution.requests],
    )
    return !solutionWithDuplicates && realizable
end

function solutionContainsDuplicates(R::Vector{Int64}, V::Vector{Int64})
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

function isVehicleAllocated(v::Int64, allocations::Dict{Int64,Vector{Int64}})
    for (_, value) in allocations
        if v in value
            return true
        end
    end
    return false
end

function solutionCorrectlyOrdered(R::Vector{Int64}, V::Vector{Int64}, Q::Vector{Int64})
    # this function assumed that there are (R_i, V_i) duplicates
    # then all vehicles associated with R_i are different
    N = length(R)
    allocations = Dict{Int64,Vector{Int64}}() # mapping requests and allocated vehicles
    for i = 1:N
        if isVehicleAllocated(V[i], allocations)
            # cannot send an allocated vehicle to another request
            return false
        else
            # Able to be allocated
            if R[i] in keys(allocations)
                push!(allocations[R[i]], V[i])
            else
                allocations[R[i]] = [V[i]]
            end
        end
        if Q[R[i]] == length(allocations[R[i]])
            # max vehicles allocated
            # clear allocations
            allocations[R[i]] = Int64[]
        end
    end
    return true
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
    parameters = Parameters(100, 100, 0.8, 0.6)

    # Initialization
    generationParent = initializeGenerationHeavyObjects(
        problem.requestsWeights,
        problem.numberOfVehicles,
        parameters.populationSize,
        rng,
    )

    # Redefine Objective function
    function fitnessFunction(solution::Chromosome)
        if solutionFeasible(solution, problem)
            return objFunction(solution.requests, solution.vehicles, problem)
        end
        return 1E-8
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
    printSolution(generationParent[1], problem.requestsWeights, problem)
end

solveMPDPHeavyObjects(5, 3, 2)

end # module
