module GeneticOperators

export selection!, crossover!, mutate!

using Random: rand, AbstractRNG
using StatsBase: sample!, Weights

Generation = Vector{Vector{Int}}

function selection!(generation::Generation, obj_function::Function, rng::AbstractRNG)
    population_size = length(generation)
    
    fitness = obj_function(chromosome)
    fitness = Weights(fitness ./ sum(fitness))
    
    idx_pop = sample(rng, 1:population_size, fitness, population_size÷2, replace=false)
    generation = generation[idx_pop]
end

function crossover!(generation::Generation, p_cross::Float64, rng::AbstractRNG)
    # get two on two combinations of chromosomes for population
    # and perform crossover
    N = length(generation)
    children = []
    for i in 1:N, j in i+1:N
        c1 = pmx_crossover(population[i], population[j], p_cross, rng)
        c2 = pmx_crossover(population[j], population[i], p_cross, rng)
        push!(generation, c1)
        push!(generation, c2)
    end
end

function pmx_crossover(chromosome::Vector{Int}, other::Vector{Int}, maxcrosslen::Float64, rng::AbstractRNG)
    N = length(chromosome)
    new_chromosome = Vector{Int}(undef, N)

    # Select a random section of the chromosome
    len = floor(Int, min(N * maxcrosslen))     # length of the crossover section
    start = floor(Int, rand(rng, 1:(N-len)))     # starting index of the crossover section

    # cross the material
    new_chromosome[start:start+len-1] = other[start:start+len-1]

    idx = 1
    for x in chromosome
        if start <= idx < start + len
            idx = start + len
        end

        if x ∉ new_chromosome[start:start+len-1]
            new_chromosome[idx] = x
            idx += 1
        end
    end
    return new_chromosome
end

function mutate!(generation::Generation, p_mutate::Float64, rng::AbstractRNG)
    for chromosome in generation
        if rand(rng) < p_mutate
            mutate!(chromosome)
        end
    end
end

function mutate!(chromosome::Vector{Int})
    nothing
end

end # module