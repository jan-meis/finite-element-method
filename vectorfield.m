classdef vectorfield
    %vectorfield class
    
    properties
        X
        Y
    end
    
    methods
        function obj = vectorfield(X, Y)
            obj.X = X;
            obj.Y = Y;
        end
        function ret = evaluate(obj, x, y)
            ret = [obj.X.evaluate(x, y); obj.Y.evaluate(x, y)];
        end
        function ret = gradient(obj)
            ret = obj.X.dx() + obj.Y.dy();
        end
    end
    
end

