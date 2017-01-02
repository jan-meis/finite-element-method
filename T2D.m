function [ ret ] = T2D( fun, x, y )
%2D Trapezoid rule numerical integration on [a,b]x[c,d]

h=x(length(x))-x(1);
k=y(length(y))-y(1);
suma=0.0;
sumb=0.0;
sumc=0.0;
sumd=0.0;

for i = x(2:length(x))
    sumc = sumc + fun.evaluate(i, y(1));
end

for i = x(2:length(x))
    sumd = sumd + fun.evaluate(i, y(length(y)));
end

for i = y(2:length(y))
    suma = suma + fun.evaluate(x(1), i;
end

for i = y(2:length(y))
    sumb = sumb + fun.evaluate(x(length(x)), i);
end

sumInside=0.0;
for i = x(2:(length(x)-1))
    for j = y(2:(length(y)-1))
        sumInside=sumInside + fun.evaluate(i, j);
    end
end

ret = 0.25*h*k*(fun.evaluate(x(1), y(1)) + fun.evaluate(x(1), y(y(length(y)))) + fun.evaluate(x((length(x))), y(y(length(y)))) ...
    + fun.evaluate(x((length(x))), y(1)) + 2*(suma + sumb + sumc + sumd) + 4*sumInside);
end

