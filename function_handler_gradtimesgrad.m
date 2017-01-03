classdef function_handler_gradtimesgrad

    properties
        fun1
        fun2
    end
    
    methods
        function [erg] = evaluate(obj, x, y)
            erg=dot(obj.fun1.gradient(x, y), obj.fun2.gradient(x, y));
        end
        
        function [x, y] = getSupport(obj)
            minx = min(obj.fun1.Px, obj.fun2.Px);
            maxx = max(obj.fun1.Px, obj.fun2.Px);
            
            if (maxx - 1.5 * obj.fun1.h < minx)
                if abs(maxx - minx) < obj.fun1.h/2
                    x=linspace(maxx -obj.fun1.h, minx + obj.fun1.h, 20);
                else
                    x=linspace(maxx -obj.fun1.h, minx + obj.fun1.h, 10);
                end
                
            else
                x = 0;
            end
            
            miny = min(obj.fun1.Py, obj.fun2.Py);
            maxy = max(obj.fun1.Py, obj.fun2.Py);
            if (maxy - 1.5 * obj.fun1.h < miny)
                if abs(maxy - miny) < obj.fun1.h/2
                    y=linspace(maxy -obj.fun1.h, miny + obj.fun1.h, 20);
                else
                    y=linspace(maxy -obj.fun1.h, miny + obj.fun1.h, 20);
                end
            else
                y = 0;
            end
        end
        
    end
    
end

