clc
clear variables
close all

A= [1, 0, 0, 0;...
    1, 0.5, 0, 0;...
    1, 0.5, 0.5, 0.25;...
    1, 0, 0.5, 0];

B=A;

b=[0,0,1,0];

b/A

inv(A)*transpose(b)


