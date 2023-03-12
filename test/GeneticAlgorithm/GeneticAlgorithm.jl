using Random: MersenneTwister

import SwarmPickupDeliveryProblem.GeneticAlgorithm.GeneticAlgorithm: initializeGeneration, Config

@testset "Test Genetic Algorithm" begin
    rng = MersenneTwister(1234)
    @testset "Test Initialize Population" begin
        solutionEncoding = [1, 2, 3, 4, 5, 6]
        generationSize = 10

        generation = initializeGeneration(solutionEncoding, generationSize, rng)

        @test length(generation) == generationSize
        @test length(generation[1]) == length(solutionEncoding)
    end

    @testset "Test Config struct" begin
        populationSize = 10
        maxGenerations = 100
        pCross = 0.8
        pMutate = 0.2

        exampleConfig = Config(populationSize, maxGenerations, pCross, pMutate)

        @test exampleConfig.populationSize == populationSize
        @test exampleConfig.maxGenerations == maxGenerations
        @test exampleConfig.pCross == pCross
        @test exampleConfig.pMutate == pMutate
    end

    @testset "Test GA function" begin
        nothing
    end
end