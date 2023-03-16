module Operators

export rouletteWheelSelection, tournamentSelection, crossover, mutate!

using Random: rand, AbstractRNG
using StatsBase: sample, Weights

Generation = Vector{Vector{Int}}

# Selection -------------------------------------------------------------------

function tournamentSelection(
    generation::Generation,
    objFunction::Function,
    rng::AbstractRNG,
)
    idxGenParents = Int[]
    for _ = 1:length(generation)
        tournament_selection!(idxGenParents, generation, objFunction, rng)
    end
    return idxGenParents
end

function tournamentSelection!(
    idxGenParents::Vector{Int},
    generation::Generation,
    objFunction::Function,
    rng::AbstractRNG,
)
    genSize = length(generation)
    idxPop = sample(rng, 1:genSize, 2, replace = false)
    fitness = [objFunction(generation[i]) for i in idxPop]
    push!(idxGenParents, idxPop[argmax(fitness)])
end

function rouletteWheelSelection(
    generation::Generation,
    objFunction::Function,
    rng::AbstractRNG,
)
    offspringSize = div(length(generation), 2)
    fitness = [objFunction(chromosome) for chromosome in generation]
    idxGenParents = Int[]
    for _ = 1:offspringSize
        rouletteWheelSelection!(idxGenParents, generation, fitness, rng)
    end
    return idxGenParents
end

function rouletteWheelSelection!(
    idxGenParents::Vector{Int},
    generation::Generation,
    fitness::Vector{Float64},
    rng::AbstractRNG,
)
    genSize = length(generation)
    weights = Weights(fitness ./ sum(fitness))
    idxParents = sample(rng, 1:genSize, weights, 2, replace = false)
    push!(idxGenParents, idxParents[1])
    push!(idxGenParents, idxParents[2])
end

# Mutation --------------------------------------------------------------------

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
    chromosome::Vector{Int},
    other::Vector{Int},
    maxCrossLen::Float64,
    rng::AbstractRNG,
)
    N = length(chromosome)
    newChromosome = Vector{Int}(undef, N)

    # Select a random section of the chromosome
    len = floor(Int, min(N * maxCrossLen))     # length of the crossover section
    start = floor(Int, rand(rng, 1:(N-len)))     # starting index of the crossover section

    # cross the material
    newChromosome[start:start+len-1] = other[start:start+len-1]

    idx = 1
    for x in chromosome
        if start <= idx < start + len
            idx = start + len
        end

        if x ∉ newChromosome[start:start+len-1]
            newChromosome[idx] = x
            idx += 1
        end
    end
    return newChromosome
end

# Mutation --------------------------------------------------------------------

function mutate!(generation::Generation, pMutate::Float64, rng::AbstractRNG)
    for chromosome in generation
        if rand(rng) < pMutate
            mutate!(chromosome, rng)
        end
    end
end

function mutate!(chromosome::Vector{Int}, rng::AbstractRNG)
    idx1, idx2 = sample(rng, 1:length(chromosome), 2, replace = false)
    chromosome[idx1], chromosome[idx2] = chromosome[idx2], chromosome[idx1]
end

end # module
