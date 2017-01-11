# finite-element-method
Github link: https://github.com/jan-meis/finite-element-method.git

# how to use
1) Download files and save them to a folder.
2) Open Matlab.
3) (Important!) Make sure the folder containing the 'main_...' files is selected as the current folder in Matlab. 
4) Run one of the 'main_...' files.


# .mesh files
These files are structures in the following way:

<#number of vertices>
<#vertex index> <x> <y> <isBoundaryPoint>
<#vertex index> <x> <y> <isBoundaryPoint>
<#vertex index> <x> <y> <isBoundaryPoint>
<#vertex index> <x> <y> <isBoundaryPoint>
...
<#number of triangles>
<index of first triangle vertex> <index of second triangle vertex> <index of third triangle vertex>
<index of first triangle vertex> <index of second triangle vertex> <index of third triangle vertex>
<index of first triangle vertex> <index of second triangle vertex> <index of third triangle vertex>
<index of first triangle vertex> <index of second triangle vertex> <index of third triangle vertex>
<index of first triangle vertex> <index of second triangle vertex> <index of third triangle vertex>
...


Note that triangle indices have to go around the triangle in a counterclockwise manner!




