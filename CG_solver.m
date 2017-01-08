function [ ret ] = CG_solver( A, b )
%my implementation of the cg method
%algorithm reference: https://en.wikipedia.org/wiki/Conjugate_gradient_method#The_resulting_algorithm

dim = size(b, 1);
epsilon = 0.0001;


x = rand(dim, 1);


r_old = b -A*x;
p = r_old;

alpha = (transpose(r_old)*r_old)/(transpose(p)*A*p);
x = x + alpha * p;
r_new = r_old - alpha * A * p;

while(norm(r_new) >= epsilon)
    beta = (transpose(r_new)*r_new) / (transpose(r_old)*r_old);
    p = beta *p + r_new;
    
    r_old = r_new;
    
    alpha = (transpose(r_old)*r_old)/(transpose(p)*A*p);
    x = x + alpha * p;
    r_new = r_old - alpha * A * p;
end

ret = x;

end

