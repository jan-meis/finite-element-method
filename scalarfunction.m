classdef scalarfunction
    %scalar function interface class
    
    properties
        fun
    end
    
    methods
        function obj = scalarfunction(fun)
            obj.fun=fun;
        end
        function ret = evaluate(obj, x, y)
            ret = obj.fun.evaluate(x, y);
        end
        function ret = integrate(obj, x1, x2, y1, y2)
            ret = obj.fun.integrate(x1, x2, y1, y2);
        end
    end
    
end

