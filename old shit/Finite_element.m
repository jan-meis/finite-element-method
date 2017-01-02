classdef Finite_element
    %A triple (K, P_K, S_K)
    %K = Cell, P_K = local ansatz functions, S_K = unisolvant linear functionals
    
    properties
        K = Cell_geometry();
        P_K
        S_K
        local_ansatzfunction;
    end
    
    methods
    end
    
end
