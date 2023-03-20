module GeneticAlgorithm

export geneticAlgorithm!, Parameters, Solution

using Random: shuffle, AbstractRNG
using StatsBase: Weights, sample

include("GeneticSolution.jl")
using .GeneticSolution: Solution

Generation = Vector{Solution}

struct Parameters
    populationSize::Int64
    maxGenerations::Int64
    pCross::Float64
    pMutate::Float64

    function Parameters(
        populationSize::Int64,
        maxGenerations::Int64,
        pCross::Float64,
        pMutate::Float64,
    )
        new(populationSize, maxGenerations, pCross, pMutate)
    end
end

function geneticAlgorithm!(
    generationParent::Generation,
    objFunction::Function,
    parameters::Parameters,
    rng::AbstractRNG,
)
    for _ = 1:parameters.maxGenerations
        # Select the parents to be mated
        idxGenerationParent = rouletteWheelSelection(generationParent, objFunction, rng)
        # Crossover
        offspring = crossover(idxGenerationParent, generationParent, parameters.pCross, rng)
        # Mutation
        mutate!(offspring, parameters.pMutate, rng)
        # Selection of the fittest
        generationParent =
            sort([generationParent; offspring], by = objFunction, rev = true)[1:parameters.populationSize]
    end
    return generationParent
end

# Selection ----------------------------------------------

function tournamentSelection(
    generation::Generation,
    objFunction::Function,
    rng::AbstractRNG,
)
    idxGenParents = Int[]
    for _ = 1:length(generation)
        idxPop = sample(rng, 1:length(generation), 2, replace = false)
        fitness = [objFunction(generation[i]) for i in idxPop]
        push!(idxGenParents, idxPop[argmax(fitness)])
    end
    return idxGenParents
end

function rouletteWheelSelection(
    generation::Generation,
    objFunction::Function,
    rng::AbstractRNG,
)
    offspringSize = div(length(generation), 2)
    fitness = [objFunction(solution) for solution in generation]
    idxGenParents = Int[]
    for _ = 1:offspringSize
        weights = Weights(fitness ./ sum(fitness))
        idxParents = sample(rng, 1:length(generation), weights, 2, replace = false)
        push!(idxGenParents, idxParents[1])
        push!(idxGenParents, idxParents[2])
    end
    return idxGenParents
end

# Crossover --------------------------------------------------

function crossover(
    idxGenerationParent::Vector{Int},
    generationParent::Generation,
    pCross::Float64,
    rng::AbstractRNG,
)
    # get two on two combinations of chromosomes for population
    # and perform crossover
    N = length(idxGenerationParent)
    offspring = Solution[]
    for i = 1:2:N-1
        j = i + 1
        c1 =
            GeneticSolution.crossover(generationParent[i], generationParent[j], pCross, rng)
        push!(offspring, c1)
    end
    return offspring
end

# Mutation ---------------------------------------------------

function mutate!(generation::Generation, pMutate::Float64, rng::AbstractRNG)
    for solution in generation
        if rand(rng) < pMutate
            GeneticSolution.mutate!(solution, rng)
        end
    end
end

end # module
