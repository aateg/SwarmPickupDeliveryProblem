using Test

@testset "Test SwarmPickupDeliveryProblem" begin
    include("Problems/Problems.jl")
    include("GeneticAlgorithm/Operators.jl")
    include("GeneticAlgorithm/GeneticAlgorithm.jl")
end
