classdef wrapper_polyplusfunc
    %wrapper class for polynomial multiplied with intrinsic function
    
    properties
        poly
        fun
    end
    
    methods
        function obj = wrapper_polyplusfunc(poly, fun)
           obj.poly=poly;
           obj.fun=fun;
        end
        function ret = evaluate(obj, x, y)
            ret = obj.poly.evaluate(x, y) + obj.fun(x, y);
        end
    end
    
end
