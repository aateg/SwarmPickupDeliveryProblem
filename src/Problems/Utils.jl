module Utils

using Random: rand, AbstractRNG
import Base: size

struct DistanceMatrix
    d::Matrix{Float64}
    X::Vector{Float64}
    Y::Vector{Float64}

    function DistanceMatrix(d, X, Y)
        new(d, X, Y)
    end
end

size(d::DistanceMatrix) = size(d.d)

function generateDistanceMatrix(N::Int64, rng::AbstractRNG)::DistanceMatrix
    X = 100 * rand(rng, N)
    Y = 100 * rand(rng, N)
    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:N, j in 1:N]
    return DistanceMatrix(d, X, Y)
end

end # modules