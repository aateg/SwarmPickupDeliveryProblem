module TSP

export TravelSalesmanProblem, generateRandomTSP, objFunction, MultipleTravelSalesmenProblem, generateRandomMTSP

include("./Utils.jl")
import .Utils: generateDistanceMatrix, DistanceMatrix

using Random: AbstractRNG

SolutionType = Vector{Int64}

struct TravelSalesmanProblem
    numberOfCities::Int64
    distanceMatrix::DistanceMatrix

    function TravelSalesmanProblem(numberOfCities::Int64, dist::DistanceMatrix)
        new(numberOfCities, dist)
    end
end

struct MultipleTravelSalesmenProblem
    numberOfCities::Int64
    numberOfSalesmen::Int64
    distanceMatrix::DistanceMatrix

    function MultipleTravelSalesmenProblem(numberOfCities::Int64, numberOfSalesmen::Int64, dist::DistanceMatrix)
        new(numberOfCities, numberOfSalesmen, dist)
    end
end

function totalDistance(x::Vector{Int64}, dist::Matrix{Float64})
    return sum(dist[x[i], x[i+1]] for i = 1:length(x)-1) + dist[x[end], x[1]]
end

function objFunction(x::Vector{Int64}, tsp::TravelSalesmanProblem)
    return 1 / totalDistance(x, tsp.distanceMatrix.d)
end

function objFunction(x::Vector{Int64}, y::Vector{Int64}, mtsp::MultipleTravelSalesmenProblem)
    # Create a dictionary of salesman to cities
    salesmenCities = Dict()
    for (idx, salesman) in enumerate(y)
        if !haskey(salesmenCities, salesman)
            salesmenCities[salesman] = [x[idx]]
        else
            push!(salesmenCities[salesman], x[idx])
        end
    end

    # Compute the total distance
    t = 0
    for salesman in keys(salesmenCities)
        t += totalDistance(salesmenCities[salesman], mtsp.distanceMatrix.d)
    end
    return 1 / t
end

function generateRandomTSP(numberOfCities::Int64, rng::AbstractRNG)
    distanceMatrix = generateDistanceMatrix(numberOfCities, rng)
    return TravelSalesmanProblem(numberOfCities, distanceMatrix)
end

function generateRandomMTSP(numberOfCities::Int64, numberOfSalesmen::Int64, rng::AbstractRNG)
    distanceMatrix = generateDistanceMatrix(numberOfCities, rng)
    return MultipleTravelSalesmenProblem(numberOfCities, numberOfSalesmen, distanceMatrix)
end

end # module
