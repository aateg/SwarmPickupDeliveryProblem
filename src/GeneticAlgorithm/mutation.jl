using StatsBase: sample
using Random: AbstractRNG

include("../Solution.jl")
import .Solution: GeneticSolution, Generation

function mutate!(generation::Generation, pMutate::Float64, rng::AbstractRNG)
    for solution in generation
        if rand(rng) < pMutate
            mutate!(solution, rng)
        end
    end
end

function mutate!(solution::GeneticSolution, rng::AbstractRNG)
    idx1, idx2 = sample(rng, 1:length(chromosome), 2, replace = false)
    solution.cchromo[idx1], solution.cchromo[idx2] =
        solution.cchromo[idx2], solution.cchromo[idx1]
    solution.vchromo[idx1], solution.vchromo[idx2] =
        solution.vchromo[idx2], solution.vchromo[idx1]
end
