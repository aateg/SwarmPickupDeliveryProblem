using StatsBase: Weights, sample
using Random: AbstractRNG

include("solution.jl")

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
    idxPop = sample(rng, 1:length(generation), 2, replace = false)
    fitness = [objFunction(generation[i]) for i in idxPop]
    push!(idxGenParents, idxPop[argmax(fitness)])
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
    weights = Weights(fitness ./ sum(fitness))
    idxParents = sample(rng, 1:length(generation), weights, 2, replace = false)
    push!(idxGenParents, idxParents[1])
    push!(idxGenParents, idxParents[2])
end
