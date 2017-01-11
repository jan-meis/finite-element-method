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
            minx = min(obj.x1, obj.x3);
            maxx = max(obj.x1, obj.x3);
            miny = min(obj.y1, obj.y3);
            maxy = max(obj.y1, obj.y3);
            if (minx <= x) && (x <= maxx) && (miny <= y) && (y <= maxy)
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
        function ret = points(obj)
            ret = [obj.x1, obj.x2, obj.x3, obj.x4; obj.y1, obj.y2, obj.y3, obj.y4];
        end
        
    end
    
end

