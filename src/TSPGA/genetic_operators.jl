module GeneticOperators

export roulette_wheel_selection, tournament_selection, crossover, mutate!

using Random: rand, AbstractRNG
using StatsBase: sample!, Weights

Generation = Vector{Vector{Int}}

function tournament_selection(generation::Generation, obj_function::Function, rng::AbstractRNG)
    fitness = obj_function.(generation)
    idx_gen_parents = Int[]
    for _ in 1:length(generation)
        tournament_selection!(idx_gen_parents, generation, obj_function, rng)
    end
    return idx_gen_parents
end

function tournament_selection!(idx_gen_parents::Vector{Int}, generation::Generation, obj_function::Function, rng::AbstractRNG)
    population_size = length(generation)
    idx_pop = sample(rng, 1:population_size, 2, replace=false)
    fitness = obj_function.(generation[idx_pop])
    push!(idx_gen_parents, idx_pop[argmax(fitness)]) 
end

function roulette_wheel_selection(generation::Generation, obj_function::Function, rng::AbstractRNG) 
    offspring_size = div(length(generation), 2)
    fitness = obj_function.(generation)
    idx_gen_parents = Int[]
    for _ in 1:offspring_size
        roulette_wheel_selection!(idx_gen_parents, generation, obj_function, rng)
    end
    return idx_gen_parents
end 

function roulette_wheel_selection!(idx_gen_parents::Vector{Int}, generation::Generation, fitness::Vector{Float64}, rng::AbstractRNG)
    population_size = length(generation)
    fitness = Weights(fitness ./ sum(fitness))
    idx_parents = sample(rng, 1:population_size, fitness, 2, replace=false)
    push!(idx_gen_parents, idx_parents[1])
    push!(idx_gen_parents, idx_parents[2])
end

function crossover!(offspring::Generation, generation::Generation, p_cross::Float64, rng::AbstractRNG)
    # get two on two combinations of chromosomes for population
    # and perform crossover
    N = length(generation)
    for i in 1:N, j in i+1:N
        c1 = pmx_crossover(population[i], population[j], p_cross, rng)
        push!(offspring, c1)
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