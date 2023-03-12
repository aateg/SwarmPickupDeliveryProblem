module Problems

export Problem, generateRandomTSP, generateRandomPDP

using Random: rand, shuffle, AbstractRNG

abstract type Problem end

struct TravelSalesmanProblem <: Problem
    numberOfCities::Int64
    distanceMatrix::Matrix{Float64}
    X::Vector{Float64}
    Y::Vector{Float64}
    objFunction::Function
    encoding::Vector{Int64}

    function TravelSalesmanProblem(numberOfCities::Int64, dist::Matrix{Float64}, X::Vector{Float64}, Y::Vector{Float64})
        function f(x::Vector{Int}, d::Matrix{Float64})
            return sum(d[x[i], x[i+1]] for i in 1:length(x)-1) + d[x[end], x[1]]
        end
        objFunction(x) = 1 / f(x, dist)
        encoding = collect(1:numberOfCities)
        new(numberOfCities, dist, X, Y, objFunction, encoding)
    end
end

struct PickupDeliveryProblem <: Problem
    numberOfPickupDeliveries::Int64
    distanceMatrix::Matrix{Float64}
    X::Vector{Float64}
    Y::Vector{Float64}
    P::Vector{Int64} # pickup locations
    D::Vector{Int64} # delivery locations
    objFunction::Function
    encoding::Vector{Int64}

    function PickupDeliveryProblem(
        numberOfPickupDeliveries::Int64, 
        dist::Matrix{Float64}, 
        X::Vector{Float64}, 
        Y::Vector{Float64}, 
        P::Vector{Int64}, 
        D::Vector{Int64}
    )
        function f(x, dist, P, D)
            s = 0
            for i in 1:length(x)-1
                if x[i] == 0
                    s += dist[end, P[x[i+1]]] # depot is the last one
                elseif x[i+1] == 0
                    s += dist[D[x[i+1]], end]
                else
                    s += dist[D[x[i]], P[x[i+1]]]
                end
            end
            if x[end] == 0
                s += dist[end, P[x[1]]]
            elseif x[1] == 0
                s += dist[D[x[end]], end]
            else
                s += dist[D[x[end]], P[x[1]]]
            end
        end
        objFunction(x) = 1 / f(x, dist, P, D)
        encoding = collect(0:numberOfPickupDeliveries)
        new(numberOfPickupDeliveries, dist, X, Y, P, D, objFunction, encoding)
    end
end

function generateDistanceMatrix(N::Int, rng::AbstractRNG)
    X = 100 * rand(rng, N)
    Y = 100 * rand(rng, N)
    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:N, j in 1:N]
    return X, Y, d
end

function generateRandomTSP(numberOfCities::Int64, rng::AbstractRNG)
    X, Y, distanceMatrix = generateDistanceMatrix(numberOfCities, rng)
    return TravelSalesmanProblem(numberOfCities, distanceMatrix, X, Y)
end

function generateRandomPDP(numberOfPickupDeliveries::Int64, rng::AbstractRNG)
    numberOfCities = 2 * numberOfPickupDeliveries + 1 # depot is the last one
    X, Y, distanceMatrix = generateDistanceMatrix(numberOfCities, rng) # depot at the N+1 position
    PandD = shuffle(rng, 1:numberOfCities-1) # exclude the depot
    P = PandD[1:numberOfPickupDeliveries]
    D = PandD[numberOfPickupDeliveries+1:numberOfCities-1]
    return PickupDeliveryProblem(numberOfPickupDeliveries, distanceMatrix, X, Y, P, D)
end

end # module