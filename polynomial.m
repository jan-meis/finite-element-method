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
        
%         function ret = laplace(obj)
%             pol1a = obj.dx();
%             pol1b = pol1a.dx();
%             temp1 = pol1b.XY;
%             
%            pol2a = obj.dy();
%            pol2b = pol2a.dy();
%            temp2 = pol2b.XY;
%            padding = NaN( max(size(temp1, 1),size(temp2, 1)) , max(size(temp1, 2) ,size(temp2, 1)));
%            padding(1:size(temp2, 1), 1:size(temp2, 2)) = temp2;
%            for i = 1:size(temp1, 1)
%                for j = 1:size(temp1, 2)
%                    if (~isnan(temp1(i, j)))
%                        if (~isnan(padding(i, j)))
%                            padding(i, j) = padding(i, j) + temp1(i, j);
%                            
%                        else
%                            padding(i ,j) = temp1(i, j);
%                        end
%                    end
%                end
%            end
%            ret = polynomial(padding);
%         end
    end
    
end



