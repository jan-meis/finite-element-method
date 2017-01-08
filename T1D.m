function [ ret ] = T1D( fun, x )
%T1D Summary of this function goes here

h = (x(2)-x(1));

sum =0;
for y = x(2:end-1)
    sum = sum + fun(y);
end

ret = h*(fun(x(1)) + fun(x(end)) + 2.0 * sum)/2.0;
end

