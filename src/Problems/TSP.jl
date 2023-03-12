module TSP

struct TravelSalesmanProblem

    numberOfCities::Int64
    distance_matrix::Matrix{Float64}
    X::Vector{Float64}
    Y::Vector{Float64}
    obj_function::Function
    encoding::Vector{Int64}

    function TravelSalesmanProblem(numberOfCities::Int64, dist::Matrix{Float64}, X::Vector{Float64}, Y::Vector{Float64})
        function f(x::Vector{Int}, d::Matrix{Float64})
            return sum(d[x[i], x[i+1]] for i in 1:length(x)-1) + d[x[end], x[1]]
        end
        obj_function(x) = 1 / f(x, dist)
        encoding = collect(1:numberOfCities)
        new(numberOfCities, dist, X, Y, obj_function, encoding)
    end
end

end # module