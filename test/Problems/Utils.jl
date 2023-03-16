import SwarmPickupDeliveryProblem.Problems.Utils: generateDistanceMatrix, DistanceMatrix
using Random: MersenneTwister

@testset "Test Utils" begin
    rng = MersenneTwister(1234)
    @testset "Test Distance Matrix" begin
        N = 10
        distanceMatrix = generateDistanceMatrix(N, rng)

        @test isa(distanceMatrix, DistanceMatrix)
        @test size(distanceMatrix) == (N, N)
        @test size(distanceMatrix.X) == (N,)
        @test size(distanceMatrix.Y) == (N,)
        for i in 1:N
            @test distanceMatrix.d[i, i] == 0.0
        end
    end
end