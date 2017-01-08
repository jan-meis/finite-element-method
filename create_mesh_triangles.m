function [ ret ] = create_mesh_triangles( numSubintervals )
%creates a mesh of triangles

h = 1.0/numSubintervals;
ret = meshpoint.empty((numSubintervals+1)^2, 0);

for j = 0:numSubintervals
    for i= 0:numSubintervals
        x = i*h;
        y = j*h;
        
        if (i == 0) || (i == numSubintervals) || (j ==0) || (j==numSubintervals)
            isBoundaryPoint=true;
        else
            isBoundaryPoint=false;
        end
        
        triangles=triangle.empty();
        
        if (0 <= i-1) && (0 <= j-1) 
            x1 = h * i;
            x2 = h * (i -1);
            x4 = h*i;
            
            y1 = h*j;
            y2 = h*j;
            y4 = h*(j-1);
            
            ID = (j-1)*numSubintervals*2 + (i-1)*2 + 1;
            triangles(end+1) = triangle(x1, x2, x4, y1, y2, y4, ID);
        end
        
        if (i+1 <= numSubintervals) && (0 <= j-1)
            x1 = i*h;
            x2 = i*h;
            x3 = (i+1)*h;
            x4 = (i+1)*h;
            
            y1 = j*h;
            y2 = (j-1)*h;
            y3 = (j-1)*h;
            y4 = j*h;
            
            ID = (j-1)*numSubintervals*2 +i*2;
            triangles(end+1) = triangle(x1, x2, x3, y1, y2, y3, ID);
            triangles(end+1) = triangle(x1, x3, x4, y1, y3, y4, ID+1);
        end
        
        if (i+1 <= numSubintervals) && (j+1 <= numSubintervals )
            x1 = i*h;
            x2 = (i+1)*h;
            x4 = i*h;
            
            y1 = j*h;
            y2 = j*h;
            y4 = (j+1)*h;
            
            ID = j*numSubintervals*2 +i*2;
            triangles(end+1) = triangle(x1, x2, x4, y1, y2, y4, ID);
        end
        
        if (0 <= i-1) && (j+1 <= numSubintervals )
            x1 = i*h;
            x2 = i*h;
            x3 = (i-1)*h;
            x4 = (i-1)*h;
            
            y1 = j*h;
            y2 = (j+1)*h;
            y3 = (j+1)*h;
            y4 = j*h;
            
            ID = j*numSubintervals*2 + (i-1)*2;
            triangles(end+1) = triangle(x1, x3, x4, y1, y3, y4, ID);
            triangles(end+1) = triangle(x1, x2, x3, y1, y2, y3, ID+1);
        end
        ret(end+1) = meshpoint(x, y, isBoundaryPoint, triangles);
    end
end
end
