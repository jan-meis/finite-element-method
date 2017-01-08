classdef wrapper_squared
    %WRAPPER_SQUARED Summary of this class goes here
    
    properties
        fun
    end
    
    methods
        function obj = wrapper_squared(fun)
            obj.fun=fun;
        end
        function ret = evaluate(obj, x, y)
            val = obj.fun.evaluate(x, y);
            ret = val*val;
        end
    end
    
end

