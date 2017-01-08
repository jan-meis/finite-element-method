function [ ret ] = exactSolution_coscos( x, y )
%determied analytically
ret = cos(pi*x)*cos(pi*y)/(2*pi^2 +1);
end

