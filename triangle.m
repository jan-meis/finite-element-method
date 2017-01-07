classdef triangle
    %triangle class
    
    properties
        x1
        x2
        x3
        y1
        y2
        y3
        ID
    end
    
    methods
        function obj = triangle(x1, x2, x3, y1, y2, y3, ID)
            obj.x1=x1;
            obj.x2=x2;
            obj.x3=x3;
            obj.y1=y1;
            obj.y2=y2;
            obj.y3=y3;
            obj.ID=ID;
        end
        function ret = contains(obj, x, y)
            % Idea from http://math2.uncc.edu/~shaodeng/TEACHING/math5172/Lectures/Lect_15.PDF
            % and http://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
            % Implementation is mine.
            
            Area = abs(obj.x1*(obj.y2 - obj.y3) + obj.x2 * (obj.y3 - obj.y1) + obj.x3 * (obj.y1 - obj.y2))/2.0;
            xi = ((obj.y3-obj.y1)*(x-obj.x1) - (obj.x3-obj.x1)*(y-obj.y1))/(2.0*Area)
            eta = (-(obj.y2-obj.y1)*(x-obj.x1)+(obj.x2-obj.x1)*(y-obj.y1))/(2.0*Area)
            
            if (xi >= 0.0) && (eta >= 0.0) && ((1 -xi - eta) >= 0.0)
                ret=true;
            else
                ret=false;
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

