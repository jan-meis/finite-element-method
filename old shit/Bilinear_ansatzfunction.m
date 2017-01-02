classdef Bilinear_ansatzfunction
    %Bilinear in all 4 Quadrants around a midpoint
    
    properties
        rDir
        tDir
        h
        xProj
        yProj
    end
    
    methods
        function [ret] = evaluate(obj, P)
            if (abs(dot(obj.rDir, P)-obj.xProj)<obj.h) && (abs(dot(obj.tDir, P) - obj.yProj)<obj.h)
                ret=abs(dot(obj.rDir, P)-obj.xProj)*abs(dot(obj.tDir, P) - obj.yProj)/(obj.h*obj.h);
            else
                ret=0.0;
            end
        end
        
        
        function [ret] = gradient(obj, P)
            if (abs(dot(obj.rDir, P)-obj.xProj)<obj.h) && (abs(dot(obj.tDir, P) - obj.yProj)<obj.h)
                ret=abs(dot(obj.rDir, P)-obj.xProj)*abs(dot(obj.tDir, P) - obj.yProj)/(obj.h*obj.h);
            else
                ret=0.0;
            end
        end
        
        
    end
    
end

