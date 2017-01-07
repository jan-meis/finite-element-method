classdef shapefunction
    %shapefunction class
    
    properties
        poly
        domain
    end
    
    methods
        function obj = shapefunction(poly, domain)
            obj.poly = poly;
            obj.domain = domain;
        end
        function ret = evaluate(obj, x, y)
            if obj.domain.contains(x, y)
                ret = obj.poly.evaluate(x, y);
            else
                ret = 0;
            end
        end
    end
    
end

