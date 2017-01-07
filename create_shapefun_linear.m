function [ ret ] = create_shapefun_linear( x1, x2, x3, y1, y2, y3, b1, b2, b3, ID)
%CREATE_SHAPEFUN_LINEAR Summary of this function goes here

A = [1, x1, y1;...
    1, x2, y2;...
    1, x3, y3];

b = [b1; b2; b3];

c = A\b;

poly = polynomial([c(1), c(3); c(2), NaN]);
tri = triangle(x1, x2, x3, y1, y2, y3, ID);
ret = shapefunction(poly, tri);
end

