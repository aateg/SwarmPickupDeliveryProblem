using Random: AbstractRNG, sample

include("solution.jl")

function mutate!(generation::Generation, pMutate::Float64, rng::AbstractRNG)
    for solution in generation
        if rand(rng) < pMutate
            mutate!(solution, rng)
        end
    end
end

function mutate!(solution::Solution, rng::AbstractRNG)
    idx1, idx2 = sample(rng, 1:length(chromosome), 2, replace = false)
    solution.cchromo[idx1], solution.cchromo[idx2] = solution.cchromo[idx2], solution.cchromo[idx1]
    solution.vchromo[idx1], solution.vchromo[idx2] = solution.vchromo[idx2], solution.vchromo[idx1]
end
