ints = cell2mat(textscan(fopen('custom_mesh.mesh'), '%d' ));
floats = fscanf(fopen('custom_mesh.mesh'), '%f' );

numVertices = ints(1);
numTriangles = ints(2 + numVertices*4);

xvals=zeros(numVertices, 0);
yvals=zeros(numVertices, 0);
boundary = zeros(numVertices, 0);

for i = 1:numVertices
    xvals(i)=floats(3 + (i-1)*4 );
    yvals(i)=floats(4 + (i-1)*4 );
    if (ints(5 + (i-1)*4))
        boundary(i) = true;
    else
        boundary(i)=false;
    end
end


triinds=triangleIndices.empty(numTriangles, 0);
for i = 1:numTriangles
    i1=ints(3+4*numVertices + (i-1)*3);
    i2=ints(4+4*numVertices + (i-1)*3);
    i3=ints(5+4*numVertices + (i-1)*3);
    triinds(i) = triangleIndices(i1, i2, i3, i);
end

ret = meshpoint.empty(numVertices, 0);
for i = 1:numVertices
     triangles=triangle.empty();
     for triind = triinds(1:end)
         if (triind.contains(i))
             rind=triind.rotate(i);
             triangles(end+1)=triangle(xvals(rind(1)), xvals(rind(2)), xvals(rind(3)), ...
                 yvals(rind(1)), yvals(rind(2)), yvals(rind(3)), triind.ID);
         end
     end
     ret(i)=meshpoint(xvals(i), yvals(i), boundary(i), triangles);
end


