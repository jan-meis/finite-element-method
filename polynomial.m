classdef polynomial
    %polynomial class
    
    properties
        XY
        %         This is a matrix with the coefficients for basis functions
        %         ordered in the following way:
        %         [1,    Y,      Y^2,   Y^3,  ...;
        %          X,    XY,     XY^2,   ...
        %          X^2,  X^2X,   ...
        %          X^3,  ...
        %          ...                           ]
    end
    
    methods
        function obj = polynomial(XY)
            obj.XY=XY;
        end
        
        
        function ret = evaluate(obj, x, y)
            ret=0;
            for i = 1:size(obj.XY, 1)
                for j = 1:size(obj.XY, 2)
                    if (~isnan(obj.XY(i, j)))
                        ret = ret + obj.XY(i, j)*x^(i-1) * y^(j-1);
                    end
                end
            end
        end
        
        function ret = dx(obj)
            if (size(obj.XY, 1) > 1)
                newXY = obj.XY(2:end, :);
                for i = 1: size(newXY, 1)
                    newXY(i, :) = i * newXY(i, :);
                end
                ret = polynomial(newXY);
            else
                ret = polynomial(0);
            end
        end
        
        function ret = dy(obj)
            if (size(obj.XY, 2) > 1)
                newXY = obj.XY(:, 2:end);
                for i = 1: size(newXY, 2)
                    newXY(:, i) = i * newXY(:, i);
                end
                ret = polynomial(newXY);
            else
                ret = polynomial(0);
            end
        end
        
        function ret = plus(obj1, obj2)
            temp1 = obj1.XY;
            temp2 = obj2.XY;
            
            padding = NaN( max(size(temp1, 1),size(temp2, 1)) , max(size(temp1, 2) ,size(temp2, 1)));
            padding(1:size(temp2, 1), 1:size(temp2, 2)) = temp2;
            for i = 1:size(temp1, 1)
                for j = 1:size(temp1, 2)
                    if (~isnan(temp1(i, j)))
                        if (~isnan(padding(i, j)))
                            padding(i, j) = padding(i, j) + temp1(i, j);
                            
                        else
                            padding(i ,j) = temp1(i, j);
                        end
                    end
                end
            end
            ret = polynomial(padding);
        end
        
        function ret = gradient(obj)
            ret = vectorfield(obj.dx(), obj.dy());
        end
        
        function ret = laplace(obj)
           ret = obj.gradient().gradient();
        end
        
        function ret = minus(obj1, obj2)
            temp1 = obj1.XY;
            temp2 = obj2.XY;
            
            padding = NaN( max(size(temp1, 1),size(temp2, 1)) , max(size(temp1, 2) ,size(temp2, 1)));
            padding(1:size(temp2, 1), 1:size(temp2, 2)) = (-1*temp2);
            for i = 1:size(temp1, 1)
                for j = 1:size(temp1, 2)
                    if (~isnan(temp1(i, j)))
                        if (~isnan(padding(i, j)))
                            padding(i, j) = padding(i, j) + temp1(i, j);
                            
                        else
                            padding(i ,j) = temp1(i, j);
                        end
                    end
                end
            end
            ret = polynomial(padding);
        end
        
        function obj = integratedx(obj, x1, x2)
            newXY = zeros(1, size(obj.XY, 2));
            for i = 1:size(obj.XY, 2)
                tempSum=0;
                for j = 1:size(obj.XY, 1)
                    if (~isnan(obj.XY(i, j)))
                        tempSum = tempSum + obj.XY(j, i)*(x2^(j+1) - x1^(j+1));
                    end
                end
                newXY(1, i) = tempSum;
            end
        end
        function obj = integratedy(obj, y1, y2)
            newXY = zeros(1, size(obj.XY, 2));
            for i = 1:size(obj.XY, 1)
                tempSum=0;
                for j = 1:size(obj.XY, 2)
                    if (~isnan(obj.XY(i, j)))
                        tempSum = tempSum + obj.XY(i, j)*(y2^(j+1) - y1^(j+1));
                    end
                end
                newXY(1, i) = tempSum;
            end
        end
        function ret = integrate(obj, x1, x2, y1, y2)
            ret = obj.integratedx(x1, x2).integratedy(y1, y2).evaluate(1, 1);
        end
        
    end
    
end



