using Test
using SwarmPickupDeliveryProblem

@testset "Test SwarmPickupDeliveryProblem" begin
    @testset "Check Duplicates" begin
        @test checkDuplicates([1, 1, 1], [1, 1, 1]) == true
        @test checkDuplicates([1, 1, 2], [1, 1, 1]) == true
        @test checkDuplicates([2, 1, 1], [2, 2, 2]) == true
        @test checkDuplicates([1, 2, 3], [1, 2, 3]) == false
        @test checkDuplicates([1, 2, 3], [1, 1, 1]) == false
        @test checkDuplicates([1, 1, 3], [1, 2, 1]) == false
    end


    @testset "Check Solution Ordering" begin
        @testset "Problem with only unit capacities" begin
            R = [1, 2, 3]
            Q = [1, 1, 1]
            V = [1, 1, 1]

            @test checkOrdering(R, V, Q) == true
        end
        @testset "Problem that sends allocated vehicle to another request" begin
            R = [1, 2, 1]
            Q = [2, 1, 2]
            V = [1, 1, 2]

            @test checkOrdering(R, V, Q) == false
        end
        @testset "Problem that changes from heavy request before current request it's finished" begin
            R = [3, 4, 8, 5, 2, 5, 3, 1, 9, 6, 2, 7, 4, 1, 7, 10]
            Q = [2, 2, 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1]
            V = [1, 2, 3, 1, 3, 3, 2, 3, 2, 3, 2, 2, 1, 2, 3, 1]

            @test checkOrdering(R, V, Q) == false
        end

        @testset "Possible Solution" begin
            R = [3, 3, 8]
            Q = [2, 2, 1]
            V = [1, 2, 1]

            @test checkOrdering(R, V, Q) == true
        end
    end
end
