module TSP

export TravelSalesmanProblem, generateRandomTSP, objFunction

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

function objFunction(x::Vector{Int64}, tsp::TravelSalesmanProblem)
    d = tsp.distanceMatrix.d
    totalDistance = sum(d[x[i], x[i+1]] for i in 1:length(x)-1) + d[x[end], x[1]]
    return 1 / totalDistance
end

function generateRandomTSP(numberOfCities::Int64, rng::AbstractRNG)
    distanceMatrix = generateDistanceMatrix(numberOfCities, rng)
    return TravelSalesmanProblem(numberOfCities, distanceMatrix)
end

end # module