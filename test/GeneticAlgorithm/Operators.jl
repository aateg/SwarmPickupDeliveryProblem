using Random: MersenneTwister
import SwarmPickupDeliveryProblem.GeneticAlgorithm.Operators: mutate!

@testset "Test Operators" begin
    rng = MersenneTwister(1234)
    @testset "Selectors" begin
        @testset "Roulette Wheel Selection" begin
            nothing
        end
    
        @testset "Tournament Selection" begin
            nothing
        end
    end

    @testset "Crossover" begin
        nothing
    end

    @testset "Mutation" begin
        @testset "Mutate Chromosome" begin
            solution = [0, 1, 2, 3]
            mutate!(solution, rng)
            @test solution != [0, 1, 2, 3]
        end
        @testset "Mutate Generation" begin
            generation = [[0, 1, 2, 3], [3, 2, 1, 0]]
            pMutate = 1.0 # ensure mutation
            mutate!(generation, pMutate, rng)
            @test generation != [[0, 1, 2, 3], [3, 2, 1, 0]]
        end
    end

end


