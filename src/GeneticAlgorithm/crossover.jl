using Random: rand, AbstractRNG

include("../Solution.jl")
import .Solution: GeneticSolution, Generation

function crossover(
    idxGenerationParent::Vector{Int},
    generationParent::Generation,
    pCross::Float64,
    rng::AbstractRNG,
)
    # get two on two combinations of chromosomes for population
    # and perform crossover
    N = length(idxGenerationParent)
    offspring = Vector{Int}[]
    for i = 1:2:N-1
        j = i + 1
        c1 = pmxCrossover(generationParent[i], generationParent[j], pCross, rng)
        push!(offspring, c1)
    end
    return offspring
end

function pmxCrossover(
    solution::GeneticSolution,
    other::GeneticSolution,
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
    newCchromosome[start:start+len-1] = other[start:start+len-1]

    idx = 1
    for x in chromosome
        if start <= idx < start + len
            idx = start + len
        end

        if x ∉ newCchromosome[start:start+len-1]
            newCchromosome[idx] = x
            idx += 1
        end
    end

    # cross the material
    newVchromosome[start:start+len-1] = other[start:start+len-1]

    return GeneticSolution(newCchromosome, newVchromosome)
end
