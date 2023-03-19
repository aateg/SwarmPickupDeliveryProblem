module GeneticAlgorithm

using Random: shuffle, AbstractRNG

include("../Solution.jl")
include("Operators.jl")

import .Operators
import .Solution: GeneticSolution, Generation

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

function geneticAlgorithm(
    generationParent::Generation,
    objFunction::Function,
    parameters::Parameters,
    rng::AbstractRNG,
)
    for _ = 1:parameters.maxGenerations
        # Select the parents to be mated
        idxGenerationParent =
            Operators.rouletteWheelSelection(generationParent, objFunction, rng)
        # Crossover
        offspring = Operators.crossover(
            idxGenerationParent,
            generationParent,
            parameters.pCross,
            rng,
        )
        # Mutation
        Operators.mutate!(offspring, parameters.pMutate, rng)
        # Selection of the fittest
        generationParent =
            sort([generationParent; offspring], by = objFunction, rev = true)[1:parameters.populationSize]
    end
    return generationParent
end

end # module
