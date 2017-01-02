classdef function_handler_gradtimesgrad

    properties
        fun1
        fun2
    end
    
    methods
        function [erg] = evaluate(obj, x, y)
            erg=dot(obj.fun1.gradient(x, y), obj.fun2.gradient(x, y));
        end
    
    end
    
end

