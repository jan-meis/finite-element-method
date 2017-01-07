function [ ret ] = G2D(fun, x1, x2, x3, y1, y2, y3)
%2D Gaussian quadrature on Triangle (x1, y1), (x2, y2), (x3, y3)
%formula taken from: http://math2.uncc.edu/~shaodeng/TEACHING/math5172/Lectures/Lect_15.PDF
%implementation is my own

Area = abs(x1*(y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2))/2.0;

omega1 = -27.0/48.0;
omega234 = 25.0/48.0;

xi1 = 1.0/3.0;
xi2 = 1.0/5.0;
xi3 = 1.0/5.0;
xi4 = 3.0/5.0;

eta1 = 1.0/3.0;
eta2 = 1.0/5.0;
eta3 = 3.0/5.0;
eta4 = 1.0/5.0;

p1 = x1*(1 - xi1 - eta1) + x2*(xi1) + x3*(eta1);
p2 = x1*(1 - xi2 - eta2) + x2*(xi2) + x3*(eta2);
p3 = x1*(1 - xi3 - eta3) + x2*(xi3) + x3*(eta3);
p4 = x1*(1 - xi4 - eta4) + x2*(xi4) + x3*(eta4);

q1 = y1*(1 - xi1 - eta1) + y2*(xi1) + y3*(eta1);
q2 = y1*(1 - xi2 - eta2) + y2*(xi2) + y3*(eta2);
q3 = y1*(1 - xi3 - eta3) + y2*(xi3) + y3*(eta3);
q4 = y1*(1 - xi4 - eta4) + y2*(xi4) + y3*(eta4);

ret = Area*(omega1 * fun.evaluate(p1, q1) + omega234 * (fun.evaluate(p2, q2) + fun.evaluate(p3, q3) + fun.evaluate(p4, q4)));
end

