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
    end
    
end

