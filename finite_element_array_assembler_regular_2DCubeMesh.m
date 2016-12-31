function [ FE_array ] = finite_element_array_assembler_regular_2DCubeMesh( M )
%Creates array of finite elements from a regular 2DCube Meshj

FE_array = Finite_element.empty(sqrt(size(M.T))-1);
for i=1:(sqrt(size(M.T))-1)
    for j=1:(sqrt(size(M.T))-1)
        P1 = M.P(1:2, (i-1)*n + j);
        P2 = M.P(1:2, (i-1)*n + j+1);
        P3 = M.P(1:2, (i)*n + j+1);
        P4 = M.P(1:2, (i)*n + j);
        fe = Finite_element();
        fe.K.P = [P1, P2, P3, P4];
        fe.K.T = [ 2, 3, 4, 1; 4, 1, 2, 3 ];
        
        
        
    end
end




end

