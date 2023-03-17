using Random: MersenneTwister

using SwarmPickupDeliveryProblem.Problems: TSP, PDP, Utils

@testset "Test Problems" begin
    rng = MersenneTwister(1234)

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
            possibleSolution = [1, 2, 3, 4]
            expectedTotalDistance =
                pdp.distanceMatrix.d[end, pdp.P[1]] + # depot to first pickup
                pdp.distanceMatrix.d[pdp.P[1], pdp.D[1]] + # pickup to delivery
                pdp.distanceMatrix.d[pdp.D[1], pdp.P[2]] + # delivery to next pickup
                pdp.distanceMatrix.d[pdp.P[2], pdp.D[2]] + # pickup to delivery
                pdp.distanceMatrix.d[pdp.D[2], pdp.P[3]] + # delivery to next pickup
                pdp.distanceMatrix.d[pdp.P[3], pdp.D[3]] + # pickup to delivery
                pdp.distanceMatrix.d[pdp.D[3], pdp.P[4]] + # delivery to next pickup
                pdp.distanceMatrix.d[pdp.P[4], pdp.D[4]] + # pickup to delivery
                pdp.distanceMatrix.d[pdp.D[4], end] # last delivery to depot

            objective = PDP.objFunction(possibleSolution, pdp)

            @test 0 < objective < 1
            @test objective ≈ 1/expectedTotalDistance atol = 0.01
        end
    end

    @testset "Test Multiple Pickup Delivery Problem" begin
        numberOfPickupDeliveries = 10
        numberOfVehicles = 4
        mpdp = PDP.generateRandomMPDP(numberOfPickupDeliveries, numberOfVehicles, rng)

        @testset "Test Random MPDP initialization" begin
            numberOfCities = 2 * numberOfPickupDeliveries + 1

            @test mpdp.numberOfPickupDeliveries == numberOfPickupDeliveries
            @test mpdp.numberOfVehicles == numberOfVehicles
            @test size(mpdp.distanceMatrix) == (numberOfCities, numberOfCities)
            @test size(mpdp.P) == (numberOfPickupDeliveries,)
            @test size(mpdp.D) == (numberOfPickupDeliveries,)
        end

        @testset "Test MPDP with one vehicle" begin
            pdp = PDP.generateRandomPDP(numberOfPickupDeliveries, rng)
            possibleSolution = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            vehicles = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            objPDP = PDP.objFunction(possibleSolution, pdp)
            objMPDP = PDP.objFunction(possibleSolution, vehicles, mpdp)

            @test objMPDP ≈ objPDP atol = 0.01
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
            for i = 1:N
                @test distanceMatrix.d[i, i] == 0.0
            end
        end
    end
end
