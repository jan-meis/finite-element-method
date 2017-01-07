function [ output_args ] = create_shapefun_quadr( x1, x2, x3, x4, x5, x6, y1, y2, y3, y4, y5, y6, b1, b2, b3, b4, b5, b6, ID )
%CREATE_SHAPEFUN_QUADR Summary of this function goes here



A = [1, x1, y1, x1*x1, x1*y1, y1*y1;...
    1, x2, y2, x2*x2, x2*y2, y2*y2;...
    1, x3, y3, x3*x3, x3*y3, y3*y3;...
    1, x4, y4, x4*x4, x4*y4, y4*y4;...
    1, x5, y5, x5*x5, x5*y5, y5*y5;...
    1, x6, y6, x6*x6, x6*y6, y6*y6];

b = [b1; b2; b3; b4; b5; b6];

c = A\b;

poly = polynomial([c(1), c(3), c(6) ; c(2), c(5), NaN; c(4), NaN, NaN]);
tri = triangle(x1, x2, x3, y1, y2, y3, ID);
ret = shapefunction(poly, tri);
end

