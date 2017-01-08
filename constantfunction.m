classdef constantfunction
    %CONSTANTFUNCTION Summary of this class goes here
    
    properties
        val
    end
    
    methods
        function obj = constantfunction(val)
            obj.val=val;
        end
        function ret = evaluate(obj, x, y)
            ret = obj.val;
        end
    end
    
end

