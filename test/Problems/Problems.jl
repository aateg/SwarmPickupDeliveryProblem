using Random: MersenneTwister

import SwarmPickupDeliveryProblem.Problems: generateRandomPDP, generateRandomTSP

@testset "Test Problems" begin
    rng = MersenneTwister(1234)

    @testset "Travel Salesman Problem" begin
        numberOfCities = 10
        tsp = generateRandomTSP(numberOfCities, rng)
        possibleSolution = tsp.encoding

        @test tsp.numberOfCities == numberOfCities
        @test size(tsp.distanceMatrix) == (numberOfCities, numberOfCities)
        @test size(tsp.X) == (numberOfCities,)
        @test size(tsp.Y) == (numberOfCities,)
        @test size(tsp.encoding) == (numberOfCities,)
        @test 0 < tsp.objFunction(possibleSolution) < 1
    end

    @testset "Pickup Delivery Problem" begin
        numberOfPickupDeliveries = 10
        numberOfCities = 2 * numberOfPickupDeliveries + 1
        pdp = generateRandomPDP(numberOfPickupDeliveries, rng)
        possibleSolution = pdp.encoding

        @test pdp.numberOfPickupDeliveries == numberOfPickupDeliveries
        @test size(pdp.distanceMatrix) == (numberOfCities, numberOfCities)
        @test size(pdp.X) == (numberOfCities,)
        @test size(pdp.Y) == (numberOfCities,)
        @test size(pdp.P) == (numberOfPickupDeliveries,)
        @test size(pdp.D) == (numberOfPickupDeliveries,)
        @test size(pdp.encoding) == (numberOfPickupDeliveries,)
        @test 0 < pdp.objFunction(possibleSolution) < 1
    end
end