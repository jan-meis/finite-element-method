classdef edge
    %edge class
    
    properties
        x1
        y1
        x2
        y2
        id1
        id2
    end
    
    methods
        function obj = edge(x1, x2, y1, y2, id1, id2)
            obj.x1 = x1;
            obj.x2 = x2;
            obj.y1 = y1;
            obj.y2 = y2;
            obj.id1=id1;
            obj.id2=id2;
        end
    end
    
end

