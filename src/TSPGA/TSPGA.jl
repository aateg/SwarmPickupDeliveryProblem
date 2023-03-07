module TSPGA

export genetic_algorithm

using Random: randperm

include("genetic_operators.jl")
import .GeneticOperators

create_chromosome(N::Int, rng::AbstractRNG) = randperm(rng, N)
initialize_generation(N::Int, population_size::Int, rng::AbstractRNG) = [create_chromosome(rng, N) for i in 1:population_size]

obj_function(chromosome::Vector{Int}, dist::Matrix{Float64}) = begin
    return 1 / sum(dist[chromosome[i], chromosome[i+1]] for i in 1:length(chromosome)-1) + dist[chromosome[end], chromosome[1]]
end

function genetic_algorithm(N, dist, population_size, max_generations, rng)

    obj_function(chromosome::Vector{Int}) = obj_function(chromosome, dist)

    generation = initialize_generation(N, population_size, rng)
    for i in 1:max_generations
        
        GeneticOperators.selection!(generation, obj_function, rng)
        GeneticOperators.crossover!(generation,  p_cross, rng)
        GeneticOperators.mutate!(generation, p_mutate, rng)

    end
    return population
end

end # module