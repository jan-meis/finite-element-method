classdef function_handler_ansatztimesintrinsic
    properties
        ansatzFun
        intrinsicFun
    end
    
    methods
        function [ret] = evaluate(obj, x, y)
            ret = obj.ansatzFun.evaluate(x, y) * obj.intrinsicFun(x, y);
        end
        
        function [x, y] = getSupport(obj)
            x = linspace(obj.ansatzFun.Px - obj.ansatzFun.h, obj.ansatzFun.Px + obj.ansatzFun.h, 20);
            y = linspace(obj.ansatzFun.Py - obj.ansatzFun.h, obj.ansatzFun.Py + obj.ansatzFun.h, 20);
        end
        
    end
    
end

