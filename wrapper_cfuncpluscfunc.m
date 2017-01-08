classdef wrapper_cfuncpluscfunc
    %wrapper_cfuncpluscfunc for custom function addition
    
    properties
        func1
        func2
    end
    
    methods
        function obj = wrapper_cfuncpluscfunc(func1, func2)
            obj.func1=func1;
            obj.func2=func2;
        end
        function ret = evaluate(obj, x, y)
            ret = obj.func1.evaluate(x, y) + obj.func2.evaluate(x, y);
        end
    end
    
end

