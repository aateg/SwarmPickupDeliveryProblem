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
        @testset "Problem with only unit capacities" begin
            R = [1, 2, 3]
            Q = [1, 1, 1]
            V = [1, 1, 1]

            @test solutionCorrectlyOrdered(R, V, Q) == true
        end
        @testset "Problem that sends allocated vehicle to another request" begin
            R = [1, 2, 1]
            Q = [2, 1, 2]
            V = [1, 1, 2]

            @test solutionCorrectlyOrdered(R, V, Q) == false
        end
        @testset "Problem that changes from heavy request before current request it's finished" begin
            R = [3, 4, 8, 5, 2, 5, 3, 1, 9, 6, 2, 7, 4, 1, 7, 10]
            Q = [2, 2, 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 1]
            V = [1, 2, 3, 1, 3, 3, 2, 3, 2, 3, 2, 2, 1, 2, 3, 1]

            @test solutionCorrectlyOrdered(R, V, Q) == false
        end

        @testset "Possible Solution" begin
            R = [3, 3, 8]
            Q = [2, 2, 1]
            V = [1, 2, 1]

            @test solutionCorrectlyOrdered(R, V, Q) == true
        end

        @testset "Requests can be different" begin
            R = [10, 9, 9, 10]
            Q = [2, 2, 2, 2]
            V = [1, 2, 3, 2]

            @test solutionCorrectlyOrdered(R, V, Q) = false
        end
    end
end
