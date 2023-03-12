using Random: MersenneTwister

import SwarmPickupDeliveryProblem.GeneticAlgorithm.GeneticAlgorithm: initializeGeneration

@testset "Test Genetic Algorithm" begin
    rng = MersenneTwister(1234)
    @testset "Test Initialize Population" begin
        solutionEncoding = [1, 2, 3, 4, 5, 6]
        generationSize = 10

        generation = initializeGeneration(solutionEncoding, generationSize, rng)

        @test length(generation) == generationSize
        @test length(generation[1]) == length(solutionEncoding)
    end

    @testset "Test GA function" begin
        nothing
    end
end