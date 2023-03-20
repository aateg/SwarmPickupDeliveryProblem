module MultiplePickupDeliveryProblem

export Problem,
    objFunction, totalDistancePairedSinglePickupDelivery, generateRandomMPDP, printProblem

using Random: AbstractRNG, shuffle

include("Utils.jl")
using .Utils: DistanceMatrix, generateDistanceMatrix

struct Problem
    numberOfPickupDeliveries::Int64
    numberOfVehicles::Int64
    distanceMatrix::DistanceMatrix
    P::Vector{Int64} # pickup locations
    D::Vector{Int64} # delivery location

    function Problem(
        numberOfPickupDeliveries::Int64,
        numberOfVehicles::Int64,
        dist::DistanceMatrix,
        P::Vector{Int64},
        D::Vector{Int64},
    )
        new(numberOfPickupDeliveries, numberOfVehicles, dist, P, D)
    end
end

function objFunction(cities::Vector{Int64}, vehicles::Vector{Int64}, problem::Problem)
    t = 0
    for vehicle = 1:problem.numberOfVehicles
        tour = cities[vehicles.==vehicle]
        if length(tour) != 0
            t += totalDistancePairedSinglePickupDelivery(
                tour,
                problem.distanceMatrix.d,
                problem.P,
                problem.D,
            )
        end
    end
    return 1 / t
end

function totalDistancePairedSinglePickupDelivery(
    x::Vector{Int64},
    dist::Matrix{Float64},
    P::Vector{Int64},
    D::Vector{Int64},
)
    s = dist[end, P[x[1]]] # depot to first pickup
    for i = 1:length(x)-1
        s += dist[P[x[i]], D[x[i]]] # pickup to delivery
        s += dist[D[x[i]], P[x[i+1]]] # delivery to next pickup
    end
    s += dist[D[x[end]], end] # last delivery to depot
    return s
end

function generateRandomMPDP(
    numberOfPickupDeliveries::Int64,
    numberOfVehicles::Int64,
    rng::AbstractRNG,
)
    numberOfCities = 2 * numberOfPickupDeliveries + 1 # depot is the last one
    distanceMatrix = generateDistanceMatrix(numberOfCities, rng) # depot at the N+1 position
    PandD = shuffle(rng, 1:numberOfCities-1) # exclude the depot
    P = PandD[1:numberOfPickupDeliveries]
    D = PandD[numberOfPickupDeliveries+1:numberOfCities-1]
    return Problem(numberOfPickupDeliveries, numberOfVehicles, distanceMatrix, P, D)
end

function printProblem(problem::Problem)
    println("Problem:")
    println("- Number of Pickup/Delivery: ", problem.numberOfPickupDeliveries)
    println("- Number of Vehicles: ", problem.numberOfVehicles)
    println("- Pickup Locations: ", problem.P)
    println("- Delivery Locations: ", problem.D)
end

end # module
