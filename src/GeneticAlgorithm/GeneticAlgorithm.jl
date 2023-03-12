module GeneticAlgorithm

export genetic_algorithm, GAConfig

using Random: shuffle, AbstractRNG

include("Operators.jl")
import .Operators

struct GAConfig

    population_size::Int64
    max_generations::Int64
    p_cross::Float64
    p_mutate::Float64

    function GAConfig(population_size::Int64, max_generations::Int64, p_cross::Float64, p_mutate::Float64)
        new(population_size, max_generations, p_cross, p_mutate)
    end
end

function initialize_generation(sol_encoding, population_size::Int, rng::AbstractRNG)
    return collect(shuffle(rng, sol_encoding) for i in 1:population_size)
end

function genetic_algorithm(sol_encoding::Vector{Int64}, obj_function::Function, config::GAConfig, rng::AbstractRNG)
    # Initialize the population
    generation_parent = initialize_generation(sol_encoding, config.population_size, rng)

    for i in 1:config.max_generations
        # Select the parents to be mated
        idx_generation_parent = GeneticOperators.roulette_wheel_selection(generation_parent, obj_function, rng)
        # Crossover
        offspring = GeneticOperators.crossover(idx_generation_parent, generation_parent, config.p_cross, rng)
        # Mutation
        #GeneticOperators.mutate!(offspring, config.p_mutate, rng)
        # Selection of the fittest
        generation_parent = sort([generation_parent; offspring], by=obj_function, rev=true)[1:config.population_size]
    end
    return generation_parent
end

end # module