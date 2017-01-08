classdef meshpoint
    %MESHPOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        isBoundaryPoint
        domains
    end
    
    methods
        function obj = meshpoint(x, y, isBoundaryPoint, domains)
            obj.x=x;
            obj.y=y;
            obj.isBoundaryPoint = isBoundaryPoint;
            obj.domains = domains;
        end
    end
    
end

