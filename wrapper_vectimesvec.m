classdef wrapper_vectimesvec
    %wrapper class for vectorfield multiplication
    
    properties
        vectorfield1
        vectorfield2
    end
    
    methods
        function obj = wrapper_vectimesvec(vectorfield1, vectorfield2)
            obj.vectorfield1 = vectorfield1;
            obj.vectorfield2 = vectorfield2;
        end
        function ret = evaluate(obj, x, y)
            ret = dot(obj.vectorfield1.evaluate(x, y), obj.vectorfield2.evaluate(x, y));
        end
        
    end
    
end

