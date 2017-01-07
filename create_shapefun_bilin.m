function [ ret ] = create_shapefun_bilin( x1, x2, x3, x4, y1, y2, y3, y4, b1, b2, b3, b4, ID )
%CREATE_SHAPEFUN_BILIN Summary of this function goes here

A = [1, x1, y1, x1*y1;...
    1, x2, y2, x2*y2;...
    1, x3, y3, x3*y3
    1, x4, y4, x4*y4];

b = [b1; b2; b3; b4];

c = A\b;

poly = polynomial([c(1), c(3); c(2), c(4)]);
squ = square(x1, x2, x3, x4, y1, y2, y3, y4, ID);
ret = shapefunction(poly, squ);
end

