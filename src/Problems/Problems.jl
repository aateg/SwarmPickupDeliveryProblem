module Problems

export generateRandomTSP, generateRandomPickupDeliveryProblem

include("TSP.jl")
include("PDP.jl")

import .TSP: TravelSalesmanProblem
import .PDP: PickupDeliveryProblem

using Random: rand, randperm, AbstractRNG

function generateDistanceMatrix(N::Int, rng::AbstractRNG)
    X = 100 * rand(rng, N)
    Y = 100 * rand(rng, N)
    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:N, j in 1:N]
    return X, Y, d
end

function generateRandomTSP(numberOfCities::Int64, rng::AbstractRNG)
    X, Y, distance_matrix = generateDistanceMatrix(numberOfCities, rng)
    return TravelSalesmanProblem(numberOfCities, distance_matrix, X, Y)
end

function generateRandomPickupDeliveryProblem(numberOfPickupDeliveries::Int64, rng::AbstractRNG)
    numberOfCities = 2 * numberOfPickupDeliveries + 1 # depot is the last one
    X, Y, distance_matrix = generateDistanceMatrix(numberOfCities, rng) # depot at the N+1 position
    PandD = randperm(rng, 1:numberOfCities-1) # exclude the depot
    P = PandD[1:numberOfPickupDeliveries]
    D = PandD[numberOfPickupDeliveries+1:numberOfCities-1]
    return PickupDeliveryProblem(numberOfPickupDeliveries, distance_matrix, X, Y, P, D)
end

end # module