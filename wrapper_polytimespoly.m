classdef wrapper_polytimespoly
    %wrapper class for polynomial multiplied with polynomial
    
    properties
        poly1
        poly2
    end
    
    methods
        function obj = wrapper_polytimespoly(poly1, poly2)
           obj.poly1=poly1;
           obj.poly2=poly2;
        end
        function ret = evaluate(obj, x, y)
            ret = obj.poly1.evaluate(x, y) * obj.poly2.evaluate(x, y);
        end
    end
    
end