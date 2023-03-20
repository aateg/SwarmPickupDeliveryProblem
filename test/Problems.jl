using Random: MersenneTwister

import SwarmPickupDeliveryProblem.PDP
import SwarmPickupDeliveryProblem.PDP.Utils

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

    end

    @testset "Test Utils" begin
        @testset "Test Random Distance Matrix Generation" begin
            N = 2
            distanceMatrix = Utils.generateDistanceMatrix(N, rng)

            @test isa(distanceMatrix, Utils.DistanceMatrix)
            @test size(distanceMatrix) == (N, N)
            @test size(distanceMatrix.X) == (N,)
            @test size(distanceMatrix.Y) == (N,)
            for i = 1:N
                @test distanceMatrix.d[i, i] == 0.0
            end
            for i = 1:N-1, j = i+1:N
                @test distanceMatrix.d[i, j] == distanceMatrix.d[j, i]
            end
        end
    end
end
