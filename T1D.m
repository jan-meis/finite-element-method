function [ ret ] = T1D( fun, x, y )
%T1D Summary of this function goes here

h = sqrt((x(2)-x(1))^2 + (y(2)-y(1))^2);

sum =0;
for i = 2:size(x,2) -1
    sum = sum + fun.evaluate(x(i), y(i));
end

ret = h*(fun.evaluate(x(1), y(1)) + fun.evaluate(x(end), y(end)) + 2.0 * sum)/2.0;
end

