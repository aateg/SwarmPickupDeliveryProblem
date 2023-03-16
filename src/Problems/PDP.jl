module PDP

export PickupDeliveryProblem, generateRandomPDP, objFunction

include("Utils.jl")
import .Utils: DistanceMatrix, generateDistanceMatrix

Solution = Vector{Int64}

struct PickupDeliveryProblem
    numberOfPickupDeliveries::Int64
    distanceMatrix::DistanceMatrix
    P::Vector{Int64} # pickup locations
    D::Vector{Int64} # delivery location

    function PickupDeliveryProblem(
        numberOfPickupDeliveries::Int64, 
        dist::Distancematrix, 
        P::Vector{Int64}, 
        D::Vector{Int64}
    )
        new(numberOfPickupDeliveries, dist, P, D)
    end
end

function generateRandomPDP(numberOfPickupDeliveries::Int64, rng::AbstractRNG)
    numberOfCities = 2 * numberOfPickupDeliveries + 1 # depot is the last one
    distanceMatrix = generateDistanceMatrix(numberOfCities, rng) # depot at the N+1 position
    PandD = shuffle(rng, 1:numberOfCities-1) # exclude the depot
    P = PandD[1:numberOfPickupDeliveries]
    D = PandD[numberOfPickupDeliveries+1:numberOfCities-1]
    return PickupDeliveryProblem(numberOfPickupDeliveries, distanceMatrix, P, D)
end

function totalDistancePairedPickupDelivery(x::Solution, dist::Matrix{Float64}, P::Vector{Int64}, D::Vector{Int64})
    s = 0
    for i in 1:length(x)-1
        s += dist[end, P[x[1]]] # depot to first pickup
        s += dist[P[x[i]], D[x[i]]] # pickup to delivery
        s += dist[D[x[i]], P[x[i+1]]] # delivery to next pickup
        s += dist[D[x[end]], end] # last delivery to depot
    end
    return s
end

function objFunction(x::Solution, pdp::PickupDeliveryProblem)
    return 1 / totalDistancePairedPickupDelivery(x, pdp.distanceMatrix.d, pdp.P, pdp.D)
end

end # module