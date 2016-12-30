%clear command Window, variables and figures
clc
clear variables
close all
%add subfolders to PATH
addpath(genpath(pwd))



%******   main   ******%




tic


toc




% if (d==2)
%     %plot 2D
%     solutionPlot = figure('Name', 'Solution Plot','NumberTitle','off');
%     solution.plot3D();
%     grid on;
%     xlabel('x');
%     ylabel('y');
%     zlabel('t');
%     
%     axis auto;
%     a = axis;
%     amax = max(abs(a));
%     axis([-amax,amax,-amax,amax,-amax,amax]);
%     hold on
%     cordSysX=[-amax/2, amax/2 ];
%     cordSysY=[0,0];
%     cordSysZ=[0,0];
%     
%     plot3(cordSysX, cordSysY, cordSysZ, 'k');
%     hold on
%     cordSysX=[0,0];
%     cordSysY=[-amax/2, amax/2 ];
%     cordSysZ=[0,0];
%     plot3(cordSysX, cordSysY, cordSysZ, 'k');
%     hold on
%     cordSysX=[0,0];
%     cordSysY=[0,0];
%     cordSysZ=[-amax/2, amax/2 ];
%     plot3(cordSysX, cordSysY, cordSysZ, 'k');
% end
% 
% if (d==1)
%     %plot 1D
%     
%     solutionPlot = figure('Name', 'Solution Plot','NumberTitle','off');
%     solution.plot2D();
%     grid on;
%     xlabel('t');
%     ylabel('y');
%     
%     axis auto;
%     a = axis;
%     amax = max(abs(a));
%     axis([-amax,amax,-amax,amax]);
%     hold on
%     cordSysX=[-amax, amax ];
%     cordSysY=[0,0];
%     plot(cordSysX, cordSysY, 'k');
%     
%     hold on
%     cordSysX=[0,0];
%     cordSysY=[-amax, amax ];
%     plot(cordSysX, cordSysY, 'k');
%     
% end
% 
% if (d > 2)
%     %plot d Dimensions
%     for i=1:d
%     solutionPlot = figure('Name', strcat('Solution Plot Dim ', num2str(i)),'NumberTitle','off');
%     solution.plotiD(i);
%     grid on;
%     xlabel('t');
%     ylabel('y');
%     
%     axis auto;
%     a = axis;
%     amax = max(abs(a));
%     axis([-amax,amax,-amax,amax]);
%     hold on
%     cordSysX=[-amax, amax ];
%     cordSysY=[0,0];
%     plot(cordSysX, cordSysY, 'k');
%     
%     hold on
%     cordSysX=[0,0];
%     cordSysY=[-amax, amax ];
%     plot(cordSysX, cordSysY, 'k');
%     
%     end
% end
% 
% 
% 
% 
% %calculate approximation errors and plot them
% approx_error=[];
% fMat=[];
% for i=transpose(solution.T)
%     fMat=[fMat, f(i, solution)];
% 
%     approx_error = [approx_error, norm(f(i, solution) - solution.differentiate(i))];
% end
% max_approx_error=max(approx_error)
% avg_error = norm(approx_error)/length(approx_error)
% 
% errorPlot = figure('Name', 'Error Plot', 'NumberTitle','off');
% plot(approx_error);

