function [ M ] = mesh_creator_Cube2D( D_Cube2D, n)
%Takes a Domain_Cube2D object and divides it into n*n equally sized cubes.
%Outputs a Mesh object

M = Mesh();
P = zeros(2, n);
start = D_Cube2D.P1;
dirRight = D_Cube2D.P2-D_Cube2D.P1;
dirTop = D_Cube2D.P4-D_Cube2D.P1;

for i = 0:(n-1)
    for j = 0:(n-1)
        P(1:2, i*n + j)= start + i*dirTop + j*dirRight;
    end
end
M.P = P;

T = zeros(4, n*n);

for i = 1:n
    for j = 1:n
        ind = zeros(4, 1);
        if (i ~=  1)
            ind(1, 0)=(i-1)*n+j;
        end
        if (j ~= n)
            ind(2, 0)=i*n+(j+1);
        end
        if (i ~= n)
            ind (3, 0)=(i+1)*n +j;
        end
        if (j ~= 1)
            ind (4,0)=i*n + (j-1);
        end
        T (1:4, (i-1)*n + j)= ind;  
    end
end
M.T=T;
end

