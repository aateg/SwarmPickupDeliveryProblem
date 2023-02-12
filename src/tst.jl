module Tst

    include("singleVehiclePDP.jl")
    import .SingleVehiclePDP

    C, P, D = SingleVehiclePDP.read_data()
    #SingleVehiclePDP.singleVehiclePickupDeliveryNoCapacityModel(C, P, D)

end # module