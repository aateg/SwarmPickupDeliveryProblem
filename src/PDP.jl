module PDP

using Random: AbstractRNG, shuffle

include("Utils.jl")
using .Utils: DistanceMatrix, generateDistanceMatrix

abstract type Problem end

struct PickupDeliveryProblem <: Problem
    numberOfPickupDeliveries::Int64
    distanceMatrix::DistanceMatrix
    P::Vector{Int64} # pickup locations
    D::Vector{Int64} # delivery location

    function PickupDeliveryProblem(
        numberOfPickupDeliveries::Int64,
        dist::DistanceMatrix,
        P::Vector{Int64},
        D::Vector{Int64},
    )
        new(numberOfPickupDeliveries, dist, P, D)
    end
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

function objFunction(x::Vector{Int64}, pdp::PickupDeliveryProblem)
    return 1 /
           totalDistancePairedSinglePickupDelivery(x, pdp.distanceMatrix.d, pdp.P, pdp.D)
end

function generateRandomPDP(numberOfPickupDeliveries::Int64, rng::AbstractRNG)
    numberOfCities = 2 * numberOfPickupDeliveries + 1 # depot is the last one
    distanceMatrix = generateDistanceMatrix(numberOfCities, rng) # depot at the N+1 position
    PandD = shuffle(rng, 1:numberOfCities-1) # exclude the depot
    P = PandD[1:numberOfPickupDeliveries]
    D = PandD[numberOfPickupDeliveries+1:numberOfCities-1]
    return PickupDeliveryProblem(numberOfPickupDeliveries, distanceMatrix, P, D)
end

# Multiple Pickup Delivery Problem ------------------------------------------------------------

struct MultiplePickupDeliveryProblem <: Problem
    numberOfPickupDeliveries::Int64
    numberOfVehicles::Int64
    distanceMatrix::DistanceMatrix
    P::Vector{Int64} # pickup locations
    D::Vector{Int64} # delivery location

    function MultiplePickupDeliveryProblem(
        numberOfPickupDeliveries::Int64,
        numberOfVehicles::Int64,
        dist::DistanceMatrix,
        P::Vector{Int64},
        D::Vector{Int64},
    )
        new(numberOfPickupDeliveries, numberOfVehicles, dist, P, D)
    end
end

function objFunction(
    cities::Vector{Int64},
    vehicles::Vector{Int64},
    mpdp::MultiplePickupDeliveryProblem,
)
    # Create a dictionary of salesman to cities
    vehiclesCities = Dict{Int64,Vector{Int64}}()
    for (idx, vehicle) in enumerate(vehicles)
        if !haskey(vehiclesCities, vehicle)
            vehiclesCities[vehicle] = [cities[idx]]
        else
            push!(vehiclesCities[vehicle], cities[idx])
        end
    end

    # Compute the total distance
    t = 0
    for vehicle in keys(vehiclesCities)
        t += totalDistancePairedSinglePickupDelivery(
            vehiclesCities[vehicle],
            mpdp.distanceMatrix.d,
            mpdp.P,
            mpdp.D,
        )
    end
    return 1 / t
end

function summary(problem::Problem)
    println("Multiple Pickup Delivery Problem")
    println("- Problem Type: Paired")
    println("- Problem Total Size: ", 2 * problem.numberOfPickupDeliveries + 1)
    println("- Number of Pickups: ", problem.numberOfPickupDeliveries)
    println("- Number of Vehicles: ", problem.numberOfVehicles)
    println("- Pickups: ", problem.P)
    println("- Deliveries: ", problem.D)
    println("\n")
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
    return MultiplePickupDeliveryProblem(
        numberOfPickupDeliveries,
        numberOfVehicles,
        distanceMatrix,
        P,
        D,
    )
end

end # module
