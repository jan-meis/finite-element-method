classdef basisfunction
    %BASISFUNCTION Summary of this class goes here
    
    properties
        shapefunctions
        basePoint
        diam
    end
    
    methods
        function obj = basisfunction(shapefunctions)
            obj.shapefunctions = shapefunctions;
            if (size(shapefunctions, 1) > 0)
                obj.basePoint = [shapefunctions(1).domain.x1; shapefunctions(1).domain.y1] ;
                obj.diam = 0;
                for shape = shapefunctions(1:end)
                    points = shape.domain.points();
                    for i = 1:size(points, 2)
                        if (norm(obj.basePoint - points(:, i))> obj.diam)
                            obj.diam = norm(obj.basePoint - points(:, i));
                        end
                    end
                end
            end
            
        end
        function ret = evaluate(obj, x, y)
            ret =0;
            
            if (norm([x;y] - obj.basePoint) <= obj.diam)
                for shape = obj.shapefunctions(1:end)
                    if shape.domain.contains(x, y)
                        ret = shape.poly.evaluate(x, y);
                    end
                end
            end
        end
    end
end

