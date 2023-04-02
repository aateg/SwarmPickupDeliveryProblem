using Test
using SwarmPickupDeliveryProblem

@testset "Test SwarmPickupDeliveryProblem" begin
    @testset "Check Duplicates" begin
        @test solutionContainsDuplicates([1, 1, 1], [1, 1, 1]) == true
        @test solutionContainsDuplicates([1, 1, 2], [1, 1, 1]) == true
        @test solutionContainsDuplicates([2, 1, 1], [2, 2, 2]) == true
        @test solutionContainsDuplicates([1, 2, 3], [1, 2, 3]) == false
        @test solutionContainsDuplicates([1, 2, 3], [1, 1, 1]) == false
        @test solutionContainsDuplicates([1, 1, 3], [1, 2, 1]) == false
    end


    @testset "Check Solution Ordering" begin
        @testset "Single vehicle problem" begin
            R = [1, 2, 3]
            Q = [1, 1, 1]
            V = [1, 1, 1]

            @test solutionCorrectlyOrdered(R, V, Q) == true
        end

        @testset "Unit Capacity problem" begin
            R = [1, 2, 3]
            Q = [1, 1, 1]
            V = [1, 2, 3]

            @test solutionCorrectlyOrdered(R, V, Q) == true
        end

        @testset "Allocated vehicles cannot go to another request" begin
            R = [1, 2, 1]
            Q = [2, 1, 2]
            V = [1, 1, 2]

            @test solutionCorrectlyOrdered(R, V, Q) == false
        end
        @testset "Wrong git testing" begin
            R = [3, 4, 8, 5, 2, 5, 3, 1, 9, 6, 2, 7, 4, 1, 7, 10]
            Q = [2, 2, 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1]
            V = [1, 2, 3, 1, 3, 3, 2, 3, 2, 3, 2, 2, 1, 2, 3, 1]

            @test solutionCorrectlyOrdered(R, V, Q) == false
        end

        @testset "Possible Solution" begin
            R = [1, 1, 2]
            Q = [2, 2, 1]
            V = [1, 2, 1]

            @test solutionCorrectlyOrdered(R, V, Q) == true
        end

        @testset "Example of delaying request 1" begin
            R = [1, 2, 2, 1]
            Q = [2, 2, 2, 2]
            V = [1, 2, 3, 2]

            @test solutionCorrectlyOrdered(R, V, Q) == true
        end
    end
end
