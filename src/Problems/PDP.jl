module PDP

export PickupDeliveryProblem

struct PickupDeliveryProblem

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
        obj_function(x) = 1 / f(x, dist, P, D)
        encoding = collect(0:numberOfPickupDeliveries)

        new(numberOfPickupDeliveries, dist, X, Y, P, D, obj_function, encoding)
    end

end

end # module