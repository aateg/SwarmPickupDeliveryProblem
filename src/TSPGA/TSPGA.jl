module TSPGA

export genetic_algorithm

using Random: randperm, AbstractRNG

include("genetic_operators.jl")
import .GeneticOperators

create_chromosome(N::Int, rng::AbstractRNG) = randperm(rng, N)
initialize_generation(N::Int, population_size::Int, rng::AbstractRNG) = [create_chromosome(rng, N) for i in 1:population_size]

obj_function(chromosome::Vector{Int}, dist::Matrix{Float64}) = begin
    return 1 / sum(dist[chromosome[i], chromosome[i+1]] for i in 1:length(chromosome)-1) + dist[chromosome[end], chromosome[1]]
end

function genetic_algorithm(N, dist, population_size, max_generations, rng)

    # Parameters
    p_cross = 0.7
    p_mutate = 0.1

    # Define the objective function
    obj_function(chromosome::Vector{Int}) = obj_function(chromosome, dist)
    # Initialize the population
    generation_parent = initialize_generation(N, population_size, rng)

    for i in 1:max_generations
        # Select the parents to be mated
        idx_generation_parent = GeneticOperators.roulette_wheel_selection(generation_parent, obj_function, rng)
        # Crossover
        offspring = GeneticOperators.crossover(idx_generation_parent, generation_parent,  p_cross, rng)
        # Mutation
        #GeneticOperators.mutate!(offspring, p_mutate, rng)
        # Selection of the fittest
        generation_parent = sort([generation_parent; offspring], by=obj_function, rev=true)[1:population_size]
    end
    return generation_parent
end

end # module