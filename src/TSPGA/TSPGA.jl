module TSPGA

export genetic_algorithm

using Random: randperm, AbstractRNG

include("genetic_operators.jl")
import .GeneticOperators

function initialize_generation(N::Int, population_size::Int, rng::AbstractRNG)
    return collect(randperm(rng, N) for i in 1:population_size)
end

function genetic_algorithm(N, dist, population_size, max_generations, rng)

    # Parameters
    p_cross = 0.7
    p_mutate = 0.1

    function obj_function(chromosome::Vector{Int}, d::Matrix{Float64})
        return 1 / (sum(d[chromosome[i], chromosome[i+1]] for i in 1:length(chromosome)-1) + d[chromosome[end], chromosome[1]])
    end

    # Define the objective function
    function fitness(chromosome::Vector{Int}) 
        return obj_function(chromosome, dist)
    end
    # Initialize the population
    generation_parent = initialize_generation(N, population_size, rng)

    for i in 1:max_generations
        # Select the parents to be mated
        idx_generation_parent = GeneticOperators.roulette_wheel_selection(generation_parent, fitness, rng)
        # Crossover
        offspring = GeneticOperators.crossover(idx_generation_parent, generation_parent,  p_cross, rng)
        # Mutation
        #GeneticOperators.mutate!(offspring, p_mutate, rng)
        # Selection of the fittest
        generation_parent = sort([generation_parent; offspring], by=fitness, rev=true)[1:population_size]
    end
    return generation_parent
end

end # module