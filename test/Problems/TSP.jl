import SwarmPickupDeliveryProblem.Problems.TSP: generateRandomTSP

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
