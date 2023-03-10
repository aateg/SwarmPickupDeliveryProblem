module PDP

export generateRandomPickupDeliveryProblem

using Random: rand, randperm, MersenneTwister, AbstractRNG

mutable struct PickupDeliveryProblem

    numberOfPickupDeliveries::Int64
    distance_matrix::Matrix{Float64}
    X::Vector{Float64}
    Y::Vector{Float64}
    pickup_locations::Vector{Int64}
    delivery_locations::Vector{Int64}
    obj_function::Function
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
        obj_function(x) = f(x, dist, P, D)
        encoding = collect(0:numberOfPickupDeliveries)

        new(numberOfPickupDeliveries, dist, X, Y, P, D, obj_function, encoding)
    end

end

function generateRandomPickupDeliveryProblem(numberOfPickupDeliveries::Int64, rng::AbstractRNG)
    numberOfCities = 2 * numberOfPickupDeliveries + 1 # depot is the last one
    X, Y, distance_matrix = generateDistanceMatrix(numberOfCities, rng) # depot at the N+1 position
    PandD = randperm(rng, 1:numberOfCities-1) # exclude the depot
    P = PandD[1:numberOfPickupDeliveries]
    D = PandD[numberOfPickupDeliveries+1:numberOfCities-1]
    return PickupDeliveryProblem(numberOfPickupDeliveries, distance_matrix, X, Y, P, D)
end

function generateDistanceMatrix(N::Int, rng::AbstractRNG)
    X = 100 * rand(rng, N)
    Y = 100 * rand(rng, N)
    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:N, j in 1:N]
    return X, Y, d
end

end # module