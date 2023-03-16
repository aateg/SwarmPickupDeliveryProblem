using Random: MersenneTwister

using SwarmPickupDeliveryProblem.Problems: TSP, PDP, Utils

@testset "Test Problems" begin
    rng = MersenneTwister(1234)

    @testset "Test Travel Salesman Problem" begin
        numberOfCities = 4
        tsp = TSP.generateRandomTSP(numberOfCities, rng)
    
        @testset "Test Random TSP initialization" begin
            @test tsp.numberOfCities == numberOfCities
            @test size(tsp.distanceMatrix) == (numberOfCities, numberOfCities)
        end
    
        @testset "Test Objective Function Calculation" begin
            possibleSolution = [1,2,3,4]
            expectedTotalDistance = tsp.distanceMatrix.d[1,2] + tsp.distanceMatrix.d[2,3] \
                + tsp.distanceMatrix.d[3,4] + tsp.distanceMatrix.d[4,1] 
    
            objective = TSP.objFunction(possibleSolution, tsp)
    
            @test 0 < objective < 1
            @test objective ≈ 1/expectedTotalDistance atol=0.01
        end
    end

    @testset "Test Pickup Delivery Problem" begin
        numberOfPickupDeliveries = 4
        pdp = PDP.generateRandomPDP(numberOfPickupDeliveries, rng)

        @testset "Test Random PDP initialization" begin
            numberOfCities = 2 * numberOfPickupDeliveries + 1
        
            @test pdp.numberOfPickupDeliveries == numberOfPickupDeliveries
            @test size(pdp.distanceMatrix) == (numberOfCities, numberOfCities)
            @test size(pdp.P) == (numberOfPickupDeliveries,)
            @test size(pdp.D) == (numberOfPickupDeliveries,)
        end

        @testset "Test Paired PDP Objective Function Calculation" begin
            possibleSolution = [1,2,3,4]
            expectedTotalDistance = pdp.distanceMatrix.d[end,pdp.P[1]] \ # depot to first pickup
                + pdp.distanceMatrix.d[pdp.P[1],pdp.D[1]] \ # pickup to delivery
                + pdp.distanceMatrix.d[pdp.D[1],pdp.P[2]] \ # delivery to next pickup
                + pdp.distanceMatrix.d[pdp.P[2],pdp.D[2]] \ # pickup to delivery
                + pdp.distanceMatrix.d[pdp.D[2],pdp.P[3]] \ # delivery to next pickup
                + pdp.distanceMatrix.d[pdp.P[3],pdp.D[3]] \ # pickup to delivery
                + pdp.distanceMatrix.d[pdp.D[3],pdp.P[4]] \ # delivery to next pickup
                + pdp.distanceMatrix.d[pdp.P[4],pdp.D[4]] \ # pickup to delivery
                + pdp.distanceMatrix.d[pdp.D[4],end] # last delivery to depot
            expectedObj = 1 / expectedTotalDistance
    
            objective = PDP.objFunction(possibleSolution, pdp)
    
            @test 0 < objective < 1
            @test objective ≈ expectedObj  atol=0.01
        end
    end
    
    @testset "Test Utils" begin
        @testset "Test Random Distance Matrix Generation" begin
            N = 10
            distanceMatrix = Utils.generateDistanceMatrix(N, rng)
    
            @test isa(distanceMatrix, Utils.DistanceMatrix)
            @test size(distanceMatrix) == (N, N)
            @test size(distanceMatrix.X) == (N,)
            @test size(distanceMatrix.Y) == (N,)
            for i in 1:N
                @test distanceMatrix.d[i, i] == 0.0
            end
        end
    end
end