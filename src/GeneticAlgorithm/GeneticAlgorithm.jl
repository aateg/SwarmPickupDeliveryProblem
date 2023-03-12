module GeneticAlgorithm

export geneticAlgorithm, Config

using Random: shuffle, AbstractRNG

include("Operators.jl")
import .Operators

struct Config
    populationSize::Int64
    maxGenerations::Int64
    pCross::Float64
    pMutate::Float64

    function Config(populationSize::Int64, maxGenerations::Int64, pCross::Float64, pMutate::Float64)
        new(populationSize, maxGenerations, pCross, pMutate)
    end
end

function initializeGeneration(solEncoding::Vector{Int64}, populationSize::Int64, rng::AbstractRNG)
    return collect(shuffle(rng, solEncoding) for i in 1:populationSize)
end

function geneticAlgorithm(solEncoding::Vector{Int64}, objFunction::Function, config::Config, rng::AbstractRNG)
    # Initialize the population
    generationParent = initializeGeneration(solEncoding, config.populationSize, rng)

    for _ in 1:config.maxGenerations
        # Select the parents to be mated
        idxGenerationParent = Operators.rouletteWheelSelection(generationParent, objFunction, rng)
        # Crossover
        offspring = Operators.crossover(idxGenerationParent, generationParent, config.pCross, rng)
        # Mutation
        #Operators.mutate!(offspring, config.pMutate, rng)
        # Selection of the fittest
        generationParent = sort([generationParent; offspring], by=objFunction, rev=true)[1:config.populationSize]
    end
    return generationParent
end

end # module