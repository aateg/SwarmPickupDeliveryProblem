module SingleVehiclePDP

    export build_spdp_model

    using JuMP
    using HiGHS

    function build_spdp_model(c, P, D, n)
        model = Model(HiGHS.Optimizer)
        set_silent(model)
        ## Sets 
        last_depot = 2n + 2
        V = union([1], P, D, [last_depot]) 
        V_without_first_depot = union(P, D, [last_depot])
        V_without_last_depot = union(P, D, )
        B = precedenceVar(P, D, n)
    
        @variable(model, x[i in V, j in V], Bin)
        @objective(model, Min, sum(c .* x) / 2)
        ## Constraints
        # 2
        @constraint(model, [j in V_without_first_depot], sum(x[:, j]) == 1)
        # 3
        @constraint(model, [i in V_without_last_depot], sum(x[i, :]) == 1)
        # 4
        for i in V
            @constraint(model, x[i, 1] == 0)
        end
        # 5
        for j in V
            @constraint(model, x[last_depot, j] == 0)
        end
        # 9 
        @constraint(model, B[P] .<= B[D])
        # 10
        for i in V
            for j in V
                @constraint(model, x[i, j] * B[i] <= B[j])
            end
        end
        # Extra
        @constraint(model, [i in V], x[i,  i] == 0)
        return model
    end
    
    function precedenceVar(P::Vector{Int64}, D::Vector{Int64}, n::Int64)
        B = zeros(2n+2)
        depot = 2n+2
        B[D] .= 2
        B[depot] = 2
        B[P] .= 1
        B[1] = 1
        return B
    end

end # module