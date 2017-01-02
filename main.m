%******   main   ******

%clear command Window, variables and figures
clc
clear variables
close all
%add subfolders to PATH
addpath(genpath(pwd))

tic

numOfSubintervals=10;
h=1.0/numOfSubintervals;
I=linspace(0.0, 1.0, numOfSubintervals+1);

ansatzFunctions=BilinearAnsatzfunction.empty(numOfSubintervals*numOfSubintervals, 0);
for i = I(2:(length(I)-1))
    for j = I(2:(length(I)-1))
        fun = BilinearAnsatzfunction();
        fun.Px=j;
        fun.Py=i;
        fun.h=h;
        ansatzFunctions(end+1)=fun;
    end
end

funhand = function_handler_gradtimesgrad();
funhand.fun1=ansatzFunctions(1);
funhand.fun2=ansatzFunctions(2);








toc

