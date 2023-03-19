module Solution

struct GeneticSolution
    cchromosome::Vector{Int64}
    vchromosome::Vector{Int64}
end

Generation = Vector{GeneticSolution}

end # module
