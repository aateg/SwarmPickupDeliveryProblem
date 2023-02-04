using JuMP
using HiGHS
using DelimitedFiles

# Questions:
# 1. The matrix C needs to include depot distances, how can I do that?
# 2. Can I use only one depot? How can I do that? I think I can't

# TODO:
# 1. Fix constraints, paper is not precise enough, use book

# Next steps:
# 1. Add capacity constraints

function precedenceVariable(P::vector{Int}, D::vector{Int})
    # create a variable B that is equal to one 
    # pickup P[i] is associated to delivery D[i] by i + n
    # I need to make some precedence constraints
    # that tells that you cannot go to D[i] before P[i]
    # I need to create a vector of size 2n
    n = size(P)
    B = zeros(2n)
    B[i in P] = 0
    B[i in D] = 1
    return B

end

function read_data()
    pathDistanceMatrix = joinpath(@__DIR__, "..", "data", "distanceMatrix.txt")
    pathPickups = joinpath(@__DIR__, "..", "data", "pickups.txt")
    pathDeliveries = joinpath(@__DIR__, "..", "data", "deliveries.txt")

    C = readdlm(open(pathDistanceMatrix), ' ', Int, '\n')
    P = readdlm(open(pathPickups), ' ', Int, '\n')
    D = readdlm(open(pathDeliveries), ' ', Int, '\n')
    return C, P, D

end

function singleVehiclePickupDeliveryNoCapacityModel(c::Matrix{Int}, P::Vector{Int}, D::Vector{Int})
    model = Model(HiGHS.Optimizer)
    set_silent(model)

    ## Sets 
    n = size(P) # 
    V = union([0], P, D)

    ## Variables
    @variable(model, x[i in V, j in V], Bin)

    ## Objective
    @objective(model, Min, sum(c[i, j] * x[i, j] for i in V, j in V)

    ## Constraints
    # Each customer is picked up exactly once
    @constraint(model, [i in P], sum(x[i, :] - x[n + i, :]) == 1) 

    # Each customer is served exactly once
    for j in J
        @constraint(model, sum(x[i, j] for i in V) == 1)
    end

    # The begin depot is not a customer
    @constraint(model, sum(x[i, 1] for i in V) == 0)
    # The end depot is not a pickup location. If I don't use this depot I don't need this constraint
    @constraint(model, sum(x[2n+1, j] for j in V) == 0)

    # Ensure that first go to pickup then delivery
    @constraint(model, B[i] < B[i+1] for i in P)

    optimize!(model)
end