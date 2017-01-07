classdef square
    %square class
    
    properties
        x1
        x2
        x3
        x4
        y1
        y2
        y3
        y4
        ID
    end
    
    methods
        function obj = square(x1, x2, x3, x4, y1, y2, y3, y4, ID)
            obj.x1=x1;
            obj.x2=x2;
            obj.x3=x3;
            obj.x4=x4;
            obj.y1=y1;
            obj.y2=y2;
            obj.y3=y3;
            obj.y4=y4;
            obj.ID=ID;
        end
        function ret = contains(obj, x, y)
            if (obj.x1 <= x) && (x <= obj.x2) && (obj.y1 <= y) && (y <= obj.y4)
                ret = true;
            else
                ret = false;
            end
        end
        function ret = eq(obj1, obj2)
            if (obj1.ID == obj2.ID)
                ret =true;
            else
                ret=false;
            end
        end
        
    end
    
end
