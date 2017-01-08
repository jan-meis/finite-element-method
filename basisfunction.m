classdef basisfunction
    %BASISFUNCTION Summary of this class goes here
    
    properties
        shapefunctions
    end
    
    methods
        function obj = basisfunction(shapefunctions)
            obj.shapefunctions = shapefunctions;
        end
        function ret = evaluate(obj, x, y)
            ret =0;
            for shape = obj.shapefunctions(1:end)
                if shape.domain.contains(x, y)
                    ret = shape.poly.evaluate(x, y);
                end
            end
        end
    end
end

