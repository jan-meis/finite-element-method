classdef BilinearAnsatzfunction
    %Has a midpoint (Px, Py) and 4 quadrants around it with sides of
    %length h
    
    
    properties
        Px
        Py
        h
    end
    
    methods
        function [erg] = evaluate(obj, x, y)
            if (((obj.Px - obj.h) <= x) && (x < obj.Px) ...
                    && ((obj.Py - obj.h) <= y) && (y < obj.Py))
                erg = 1 + (x-obj.Px)/obj.h + (y - obj.Py)/obj.h + ...
                    (x - obj.Px)*(y - obj.Py)/(obj.h*obj.h);
            elseif ((obj.Px <= x) && (x <= (obj.Px+obj.h)) ...
                    && ((obj.Py - obj.h) <= y) && (y < obj.Py))
                erg = 1 - (x-obj.Px)/obj.h + (y - obj.Py)/obj.h - ...
                    (x - obj.Px)*(y - obj.Py)/(obj.h*obj.h);

                
            elseif (((obj.Px - obj.h) <= x) && (x < obj.Px) ...
                    && (obj.Py <= y) && (y <= obj.Py+obj.h))
                erg = 1 + (x-obj.Px)/obj.h - (y - obj.Py)/obj.h - ...
                    (x - obj.Px)*(y - obj.Py)/(obj.h*obj.h);
                
            elseif ((obj.Px <= x) && (x <= (obj.Px+obj.h)) ...
                    && (obj.Py <= y) && (y <= obj.Py+obj.h))
                erg = 1 - (x-obj.Px)/obj.h - (y - obj.Py)/obj.h + ...
                    (x - obj.Px)*(y - obj.Py)/(obj.h*obj.h);
                
            else
                erg=0.0;
            end
        end
        
        %Note that grad(Px, Py) is not handled correctly, but in our case
        %that does not matter because it will be multiplied by 0.
        function [erg] = gradient(obj, x, y)
            epsilon = obj.h/10000;
            
            if (((obj.Px - obj.h) <= x - epsilon) && (x- epsilon < obj.Px) ...
                    && ((obj.Py - obj.h) <= y - epsilon) && (y- epsilon< obj.Py))
                erg = [1.0/obj.h - obj.Py/(obj.h*obj.h) + y/(obj.h*obj.h), ...
                    1.0/obj.h - obj.Px/(obj.h*obj.h) + x/(obj.h*obj.h)];
                
            elseif ((obj.Px <= x+ epsilon ) && (x + epsilon <= (obj.Px+obj.h)) ...
                    && ((obj.Py - obj.h) <= y - epsilon) && (y- epsilon < obj.Py))
                erg = [-1.0/obj.h + obj.Py/(obj.h*obj.h) - y/(obj.h*obj.h), ...
                    1.0/obj.h + obj.Px/(obj.h*obj.h) - x/(obj.h*obj.h)];
                
            elseif (((obj.Px - obj.h) <= x - epsilon) && (x- epsilon  < obj.Px) ...
                    && (obj.Py <= y+epsilon ) && (y +epsilon <= obj.Py+obj.h))
                erg = [1.0/obj.h + obj.Py/(obj.h*obj.h) - y/(obj.h*obj.h), ...
                    -1.0/obj.h + obj.Px/(obj.h*obj.h) - x/(obj.h*obj.h)];
                
            elseif ((obj.Px <= x+epsilon ) && (x+epsilon <= (obj.Px+obj.h)) ...
                    && (obj.Py <= y+epsilon) && (y+epsilon <= obj.Py+obj.h))
                erg = [-1.0/obj.h - obj.Py/(obj.h*obj.h) + y/(obj.h*obj.h), ...
                    -1.0/obj.h - obj.Px/(obj.h*obj.h) + x/(obj.h*obj.h)];
                
            else
                erg=[0.0, 0.0];
            end
        end
        
    end
end

