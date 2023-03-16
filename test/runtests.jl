using Test

@testset "Test SwarmPickupDeliveryProblem" begin
    include("Problems/Problems.jl")
    include("Problems/Utils.jl")
    include("GeneticAlgorithm/Operators.jl")
    include("GeneticAlgorithm/GeneticAlgorithm.jl")
end