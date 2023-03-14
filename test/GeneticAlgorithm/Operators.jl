using Random: MersenneTwister
import SwarmPickupDeliveryProblem.GeneticAlgorithm.Operators

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
        solution = [0, 1, 2, 3]
        pMutate = 1
        mutate!(solution, pMutate, rng)
        @test solution != [0, 1, 2, 3]
    end

end


