%******   main   ******

%clear command Window, variables and figures
clc
clear variables
close all
%add subfolders to PATH
addpath(genpath(pwd))



neumann = false; %dirichlet boundary conditions

%mesh configurations: square mesh with numSubintervals^2 squares

for numSubintervals = 1:5
    
    starttime = tic;
    disp('****************************************************************************')
    disp(['Starting compution for ' num2str(numSubintervals) ' subintervals:'])
    
    disp(' ')
    
    tic
    disp('Creating mesh...')
    mesh = create_mesh_squares(numSubintervals);
    disp('mesh creation done!')
    toc
    
    disp(' ')
    
    tic
    disp('Creating basis functions...')
    %create array of bilinear basisfunctions
    basisfunctions = basisfunction.empty();
    for p = mesh(1:end)
        if (~p.isBoundaryPoint || neumann)
            shapefunctions = shapefunction.empty();
            for d = p.domains(1:end)
                shapefunctions(end+1) = create_shapefun_bilin(d.x1, d.x2, d.x3, d.x4, d.y1, d.y2, d.y3, d.y4, 1, 0, 0, 0, d.ID);
            end
            basisfunctions(end+1)=basisfunction(shapefunctions);
        end
    end
    disp('finished creating basis functions!')
    toc
    
    disp(' ')
    
    tic
    disp('Assembling system matrix...')
    %assemble matrix
    A = zeros(size(basisfunctions, 2));
    for i = 1:size(basisfunctions, 2)
        phi_i = basisfunctions(i);
        for j = 1:size(basisfunctions, 2)
            phi_j = basisfunctions(j);
            aij=0;
            for shape_i = phi_i.shapefunctions(1:end)
                grad_i = shape_i.poly.gradient();
                for shape_j = phi_j.shapefunctions(1:end)
                    if (shape_i.domain == shape_j.domain)
                        grad_j = shape_j.poly.gradient();
                        fun = grad_i * grad_j;
                        aij = aij + T2D(fun,...
                            linspace(min(shape_i.domain.x1, shape_i.domain.x3), max(shape_i.domain.x1, shape_i.domain.x3), 15), ...
                            linspace(min(shape_i.domain.y1, shape_i.domain.y3), max(shape_i.domain.y1, shape_i.domain.y3), 15));
                    end
                end
            end
            A(i, j) = aij;
        end
    end
    disp('finished assembling system matrix!')
    toc
    
    disp(' ')
    
    tic
    disp('Assembling right hand side...')
    %assemble right hand side
    b = zeros(size(basisfunctions, 2), 1);
    for i = 1:size(basisfunctions, 2)
        phi_i = basisfunctions(i);
        bi=0;
        
        for shape_i = phi_i.shapefunctions(1:end)
            fun = scalarfunction(wrapper_polytimesfunc(shape_i.poly, @sinsin));
            bi = bi + T2D(fun,...
                linspace(min(shape_i.domain.x1, shape_i.domain.x3), max(shape_i.domain.x1, shape_i.domain.x3), 15), ...
                linspace(min(shape_i.domain.y1, shape_i.domain.y3), max(shape_i.domain.y1, shape_i.domain.y3), 15));
        end
        
        b(i) = bi;
    end
    disp('finished assembling right hand side!')
    toc
    
    disp(' ')
    
    tic
    disp('Solving system of equations...')
    %solve
    coefficients = A\b;
    disp('finished solving system of equations!')
    toc
    
    disp(' ')
    
    tic
    disp('Calculating a posteriori error estimate...')
    %calculate a posteriori error estimate
    %Disclaimer: this is actually really stupid because the laplace of a
    %bilinear function is 0, so only the edge integrals over the edges
    %contribute something.
    aposteriorierror=0;
    for phi = basisfunctions(1:end)
        for shape = phi.shapefunctions(1:end)
            funK = scalarfunction(wrapper_squared(wrapper_polytimesfunc(shape.poly.laplace(), @sinsin)));
            ex1x2 = shape.domain.x2 - shape.domain.x1;
            ex2x3 = shape.domain.x3 - shape.domain.x2;
            ex3x4 = shape.domain.x4 - shape.domain.x3;
            ex4x1 = shape.domain.x4 - shape.domain.x1;
            
            ey1y2 = shape.domain.y2 - shape.domain.y1;
            ey2y3 = shape.domain.y3 - shape.domain.y2;
            ey3y4 = shape.domain.y4 - shape.domain.y3;
            ey4y1 = shape.domain.y4 - shape.domain.y1;
            
            e12 = sqrt(ex1x2^2+ey1y2^2);
            e23 = sqrt(ex2x3^2+ey2y3^2);
            e34 = sqrt(ex3x4^2+ey3y4^2);
            e41 = sqrt(ex4x1^2+ey4y1^2);
            
            diamK = max(max(e12, e23), max( e34, e41));
            
            resK = diamK^2 * T2D(funK,...
                linspace(min(shape.domain.x1, shape.domain.x3), max(shape.domain.x1, shape.domain.x3), 15), ...
                linspace(min(shape.domain.y1, shape.domain.y3), max(shape.domain.y1, shape.domain.y3), 15));
            
            
            conste12x = constantfunction(-ey1y2);
            conste12y = constantfunction(ex1x2);
            vec12 = vectorfield(conste12x, conste12y);
            funE1 = scalarfunction(wrapper_squared(shape.poly.gradient() * vec12));
            
            conste23x = constantfunction(-ey2y3);
            conste23y = constantfunction(ex2x3);
            vec23 = vectorfield(conste23x, conste23y);
            funE2 = scalarfunction(wrapper_squared(shape.poly.gradient() * vec23));
            
            conste34x = constantfunction(-ey3y4);
            conste34y = constantfunction(ex3x4);
            vec34 = vectorfield(conste34x, conste34y);
            funE3 = scalarfunction(wrapper_squared(shape.poly.gradient() * vec34));
            
            conste41x = constantfunction(-ey4y1);
            conste41y = constantfunction(ex4x1);
            vec41 = vectorfield(conste41x, conste41y);
            funE4 = scalarfunction(wrapper_squared(shape.poly.gradient() * vec41));
            
            resE = (1.0/2.0)*(...
                e12*T1D(funE1, linspace(shape.domain.x1, shape.domain.x2, 10), linspace(shape.domain.y1, shape.domain.y2, 15))...
                + e23*T1D(funE2, linspace(shape.domain.x2, shape.domain.x3, 10), linspace(shape.domain.y2, shape.domain.y3, 15))...
                + e34*T1D(funE3, linspace(shape.domain.x3, shape.domain.x4, 10), linspace(shape.domain.y3, shape.domain.y4, 15))...
                + e41*T1D(funE4, linspace(shape.domain.x4, shape.domain.x1, 10), linspace(shape.domain.y4, shape.domain.y1, 15))...
                );
            aposteriorierror = aposteriorierror + resE + resK;
        end
    end
    aposteriorierror = sqrt(aposteriorierror);
    disp(['finished calculating a posteriori error estimate: ' num2str(aposteriorierror)]);
    toc
    
    disp(' ')
    
    tic
    disp('Evaluating solution function on a 100x100 grid...')
    %evaluate
    solution = zeros(101, 101);
    for i = 0:100
        for j = 0:100
            tempSum=0.0;
            for k = 1:length(basisfunctions)
                tempSum = tempSum + coefficients(k) * basisfunctions(k).evaluate(i/100.0 , j/100.0);
            end
            solution(i+1, j+1) = tempSum;
        end
    end
    disp('finished evaluating solution function')
    toc
    
    disp(' ')
    
    tic
    disp('Visualizing solution data...')
    %draw
    xAxis = linspace(0, 1, 101);
    yAxis = linspace(0, 1, 101);
    figure('Name',['Solution plot for ' num2str(numSubintervals) ' subintervals'] , 'NumberTitle','off');
    surf(xAxis, yAxis, solution);
    disp('finished visualizing solution!')
    toc
    
    disp(' ')
    
    disp(['Computation for ' num2str(numSubintervals) ' finished!'])
    toc(starttime)
    disp('****************************************************************************')
end
















%
%
% %create array of gradients of bilinear basisfunctions
% basisfunctiongrads = basisfunction.empty();
% for basefun = basisfunctions(1:end)
%     shapefunctions = shapefunction.empty();
%     for shapefun = basefun.shapefunctions(1:end)
%         domain = shapefun.domain;
%         gradpoly = shapefun.poly.gradient();
%         shapefunctions(end+1) = shapefunction(gradpoly, domain);
%     end
%     basisfunctiongrads(end+1)= basisfunction(shapefunctions);
% end
%
%
%
%
%
%
%
%
%












% numOfSubintervals=10;
% h=1.0/numOfSubintervals;
% I=linspace(0.0, 1.0, numOfSubintervals+1);
%
% ansatzFunctions=BilinearAnsatzfunction.empty(numOfSubintervals*numOfSubintervals, 0);
% for i = I(2:(length(I)-1))
%     for j = I(2:(length(I)-1))
%         fun = BilinearAnsatzfunction();
%         fun.Px=j;
%         fun.Py=i;
%         fun.h=h;
%         ansatzFunctions(end+1)=fun;
%     end
% end
%
% functionHandlerArrayGradGrad = function_handler_gradtimesgrad.empty(length(ansatzFunctions), 0);
% functionHandlerArrayAnsatzIntrinsic = function_handler_ansatztimesintrinsic.empty(length(ansatzFunctions), 0);
% for fun1 = ansatzFunctions(1:length(ansatzFunctions))
%     handler2=function_handler_ansatztimesintrinsic();
%     handler2.ansatzFun = fun1;
%     handler2.intrinsicFun = @sinsin;
%     functionHandlerArrayAnsatzIntrinsic(end+1)=handler2;
%     for fun2 = ansatzFunctions(1:length(ansatzFunctions))
%         handler1=function_handler_gradtimesgrad();
%         handler1.fun1 = fun1;
%         handler1.fun2 = fun2;
%         functionHandlerArrayGradGrad(end+1)=handler1;
%     end
% end
%
% A = zeros(length(functionHandlerArrayAnsatzIntrinsic), length(functionHandlerArrayAnsatzIntrinsic));
% for i = 1:length(ansatzFunctions)
%     for j = 1:length(ansatzFunctions)
%        handle = functionHandlerArrayGradGrad(j + (i-1)*length(ansatzFunctions));
%        [x, y] = handle.getSupport();
%        if ((length(x) ~=1) && (length(y) ~= 1))
%            A(i,j) = T2D(handle, x, y);
%        else
%            A(i,j)=0;
%        end
%     end
% end
%
% b = zeros(length(functionHandlerArrayAnsatzIntrinsic), 0);
% for i = 1:length(ansatzFunctions)
%     handle = functionHandlerArrayAnsatzIntrinsic(i);
%     [x, y] = handle.getSupport();
%     b(i) = T2D(handle, x, y);
% end
%
% coefficients = A\transpose(b);
%
% testcoeff = inv(A)*transpose(b);
%
%
% solution = zeros(101, 101);
%
% for i = 0:100
%     for j = 0:100
%         tempSum=0.0;
%         for k = 1:length(ansatzFunctions)
%             tempSum=tempSum + coefficients(k)*ansatzFunctions(k).evaluate(i/100.0 , j/100.0);
%         end
%         solution(i+1, j+1) = tempSum;
%     end
% end
%
% xAxis = linspace(0, 1, 101);
% yAxis = linspace(0, 1, 101);
%
% surf(xAxis, yAxis, solution);



