module TSPGA

export generate_distance_matrix, genetic_algorithm

using Random
using StatsBase: sample, Weights

function generate_distance_matrix(N, rng)
    
    X = 100 * rand(rng, N)
    Y = 100 * rand(rng, N)
    d = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:N, j in 1:N]
    return X, Y, d
end

create_initial_population(N, population_size, rng) = [randperm(rng, N) for i in 1:population_size]

function evaluation(chromosome, dist)
    N = length(chromosome)
    total_dist = sum(dist[chromosome[i], chromosome[i+1]] for i in 1:N-1) + dist[chromosome[N], chromosome[1]]
    return 1 / total_dist
end

function selection!(population, dist, rng)
    population_size = length(population)
    idx_pop = 1:population_size
    
    fitness = [evaluation(chromosome, dist) for chromosome in population]
    fitness = Weights(fitness ./ sum(fitness))
    
    sample(rng, idx_pop, fitness, population_size÷2)
    population = population[idx_pop]
end

function crossover!(population, rng)
    # get two on two combinations of chromosomes for population
    # and perform crossover
    N = length(population)
    children = []
    for i in 1:N, j in i+1:N
        c1, c2 = pmx_crossover(population[i], population[j], rng)
        push!(children, c1)
        push!(children, c2)
    end
    population = children
end

function pmx_crossover(chromosome1, chromosome2, rng)
    N = length(chromosome1)
    new_chromosome1 = Vector{Int}(undef, N)
    new_chromosome2 = Vector{Int}(undef, N)

    # Select a random section of the chromosome
    maxcrosslen = 0.6
    len = floor(Int, min(N * maxcrosslen))     # length of the crossover section
    start = floor(Int, rand(rng, 1:(N-len)))     # starting index of the crossover section

    # cross the material
    new_chromosome1[start:start+len-1] = chromosome2[start:start+len-1]
    new_chromosome2[start:start+len-1] = chromosome1[start:start+len-1]

    idx = 1
    for x in chromosome1
        if start <= idx < start + len
            idx = start + len
        end

        if x ∉ new_chromosome1[start:start+len-1]
            new_chromosome1[idx] = x
            idx += 1
        end
    end

    idx = 1
    for x in chromosome2
        if start <= idx < start + len
            idx = start + len
        end

        if x ∉ new_chromosome2[start:start+len-1]
            new_chromosome2[idx] = x
            idx += 1
        end
    end

    return new_chromosome1, new_chromosome2
end

function genetic_algorithm(N, dist, population_size, max_generations, rng)
    population = create_initial_population(N, population_size, rng)
    for i in 1:max_generations
        genetic_algorithm_one!(population, dist, rng)
    end
    return population
end

function genetic_algorithm_one!(population, dist, rng)
    selection!(population, dist, rng)
    crossover!(population, rng)
    #population = [mutate(chromosome, rng) for chromosome in population]
end


end # module