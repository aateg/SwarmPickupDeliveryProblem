module GeneticSolution

export Solution, crossover, mutate!

using StatsBase: sample
using Random: rand, AbstractRNG

struct Solution
    cchromosome::Vector{Int64}
    vchromosome::Vector{Int64}
end

# Crossover --------------------------------------------------
# PMX Crossover
function crossover(
    solution::Solution,
    other::Solution,
    maxCrossLen::Float64,
    rng::AbstractRNG,
)
    N = length(solution.cchromosome)
    newCchromosome = Vector{Int64}(undef, N)
    newVchromosome = copy(solution.vchromosome)

    # Select a random section of the chromosome
    len = floor(Int, min(N * maxCrossLen))     # length of the crossover section
    start = floor(Int, rand(rng, 1:(N-len)))     # starting index of the crossover section

    # cross the material
    newCchromosome[start:start+len-1] = other.cchromosome[start:start+len-1]

    idx = 1
    for x in solution.cchromosome
        if start <= idx < start + len
            idx = start + len
        end

        if x ∉ newCchromosome[start:start+len-1]
            newCchromosome[idx] = x
            idx += 1
        end
    end

    # cross the material
    newVchromosome[start:start+len-1] = other.vchromosome[start:start+len-1]

    return Solution(newCchromosome, newVchromosome)
end

# Mutation ---------------------------------------------------

function mutate!(solution::Solution, rng::AbstractRNG)
    idx1, idx2 = sample(rng, 1:length(solution.cchromosome), 2, replace = false)
    solution.cchromosome[idx1], solution.cchromosome[idx2] =
        solution.cchromosome[idx2], solution.cchromosome[idx1]
    solution.vchromosome[idx1], solution.vchromosome[idx2] =
        solution.vchromosome[idx2], solution.vchromosome[idx1]
end

end # module
