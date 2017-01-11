classdef triangleIndices
    %TRIANGLEINDICES Summary of this class goes here
    
    properties
        i1
        i2
        i3
        ID
    end
    
    methods
        function obj = triangleIndices(i1, i2, i3, ID)
            obj.i1 = i1;
            obj.i2 = i2;
            obj.i3 = i3;
            obj.ID=ID;
        end
        function ret = contains(obj, ind)
            ret = ((ind==obj.i1) || (ind==obj.i2) || (ind==obj.i3) );
        end
        function ret = rotate(obj, ind)
            if (ind == obj.i1)
                ret = [obj.i1, obj.i2, obj.i3];
            end
            if (ind == obj.i2)
                ret = [obj.i2, obj.i3, obj.i1];
            end
            if (ind == obj.i3)
                ret = [obj.i3, obj.i1, obj.i2];
            end
        end
    end
    
end

