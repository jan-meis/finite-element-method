%******   main   ******

%clear command Window, variables and figures
clc
clear variables
close all
%add subfolders to PATH
addpath(genpath(pwd))

neumann = false; %dirichlet boundary conditions

%calculate reference solution for comparison with approximate solutions
referenceSolution = zeros(101);
for i = 0:100
    for j = 0:100
        referenceSolution(i+1, j+1) = exactSolution_sinsin(i/100.0, j/100.0);
    end
end
%analytically integrated:
referenceIntegral = 2 / pi^4;


starttime = tic;
disp('****************************************************************************')
disp('Starting compution')

disp(' ')

tic
disp('Loading mesh...')
%mesh configurations: square mesh with numSubintervals^2 squares
mesh = create_mesh_triangles_fromfile('custom_mesh.mesh');
disp('mesh loading done!')
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
            eval1=sinsin(d.x1, d.y1);
            eval3=sinsin((d.x1+d.x2)/2,(d.y1+d.y2)/2 );
            eval5 = sinsin((d.x3+d.x1)/2,(d.y3+d.y1)/2);
            
            shapefunctions(end+1) = create_shapefun_quadr(d.x1, (d.x1+d.x2)/2, d.x2, (d.x2+d.x3)/2,  d.x3, (d.x3+d.x1)/2,...
                d.y1, (d.y1+d.y2)/2, d.y2, (d.y2+d.y3)/2, d.y3, (d.y3+d.y1)/2, 1, 0.5*eval3/eval1, 0, 0, 0, 0.5*eval5/eval1, d.ID);
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
                    aij = aij + G2D(fun,shape_i.domain.x1, shape_i.domain.x2, shape_i.domain.x3, ...
                        shape_i.domain.y1, shape_i.domain.y2, shape_i.domain.y3);
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
        bi = bi + G2D(fun,shape_i.domain.x1, shape_i.domain.x2, shape_i.domain.x3, ...
            shape_i.domain.y1, shape_i.domain.y2, shape_i.domain.y3);
    end
    
    b(i) = bi;
end
disp('finished assembling right hand side!')
toc

disp(' ')

tic
disp('Solving system of equations with CG solver...')
%solve
coefficients = CG_solver(A, b);
disp('finished solving system of equations!')
toc

disp(' ')


tic
disp('Evaluating solution function on a 101x101 grid...')
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
disp('Calculating a posteriori error estimate with error estimator eta (page 290 in Grossmann & Roos)...')
%calculate a posteriori error estimate
%Disclaimer: this is actually really stupid because the laplace of a
%bilinear function is 0, so only the edge integrals over the edges
%contribute something.
aposteriorierror=0;
for phi = basisfunctions(1:end)
    for shape = phi.shapefunctions(1:end)
        funK = scalarfunction(wrapper_squared(wrapper_polyplusfunc(shape.poly.laplace(), @sinsin)));
        ex1x2 = shape.domain.x2 - shape.domain.x1;
        ex2x3 = shape.domain.x3 - shape.domain.x2;
        ex3x1 = shape.domain.x1 - shape.domain.x3;
        
        
        ey1y2 = shape.domain.y2 - shape.domain.y1;
        ey2y3 = shape.domain.y3 - shape.domain.y2;
        ey3y1 = shape.domain.y1 - shape.domain.y3;
        
        
        e12 = sqrt(ex1x2^2+ey1y2^2);
        e23 = sqrt(ex2x3^2+ey2y3^2);
        e31 = sqrt(ex3x1^2+ey3y1^2);
        
        diamK = max(max(e12, e23), e31);
        
        resK = diamK^2 * G2D(funK ,shape.domain.x1, shape.domain.x2, shape.domain.x3, ...
            shape.domain.y1, shape.domain.y2, shape.domain.y3);
        
        
        conste12x = constantfunction(-ey1y2);
        conste12y = constantfunction(ex1x2);
        vec12 = vectorfield(conste12x, conste12y);
        funE1 = scalarfunction(wrapper_squared(shape.poly.gradient() * vec12));
        
        conste23x = constantfunction(-ey2y3);
        conste23y = constantfunction(ex2x3);
        vec23 = vectorfield(conste23x, conste23y);
        funE2 = scalarfunction(wrapper_squared(shape.poly.gradient() * vec23));
        
        conste31x = constantfunction(-ey3y1);
        conste31y = constantfunction(ex3x1);
        vec31 = vectorfield(conste31x, conste31y);
        funE3 = scalarfunction(wrapper_squared(shape.poly.gradient() * vec31));
        
        
        resE = (1.0/2.0)*(...
            e12*T1D(funE1, linspace(shape.domain.x1, shape.domain.x2, 10), linspace(shape.domain.y1, shape.domain.y2, 15))...
            + e23*T1D(funE2, linspace(shape.domain.x2, shape.domain.x3, 10), linspace(shape.domain.y2, shape.domain.y3, 15))...
            + e31*T1D(funE3, linspace(shape.domain.x3, shape.domain.x1, 10), linspace(shape.domain.y3, shape.domain.y1, 15)));
        
        aposteriorierror = aposteriorierror + resE + resK;
    end
end
aposteriorierror = sqrt(aposteriorierror);
disp(['finished calculating a posteriori error estimate: ' num2str(aposteriorierror)]);
toc

disp(' ')


tic
disp('Calculating absolute and relative error on 101x101 Grid with 2D composite trapezoid rule...')
%calc absolute error
abserrormat = abs(solution - referenceSolution);
abserrormat(2:end-1, :) = 2*abserrormat(2:end-1, :);
abserrormat(:, 2:end-1) = 2*abserrormat(:, 2:end-1);
abserror = 0.0;
for i = 0:100
    for j = 0:100
        abserror = abserror + abserrormat(i+1, j+1);
    end
end
abserror = abserror * 0.25 * (1/100.0)^2;
relerror = abserror / referenceIntegral;
disp(['finished calculating absolute error: ' num2str(abserror)])
disp(['finished calculating relative error: ' num2str(relerror)])
toc

disp(' ')




tic
disp('Visualizing solution data...')
%draw
xAxis = linspace(0, 1, 101);
yAxis = linspace(0, 1, 101);
figure('Name',['Solution plot'] , 'NumberTitle','off');
surf(xAxis, yAxis, solution);
disp('finished visualizing solution!')
toc

disp(' ')

disp(['Computation finished!'])
toc(starttime)
disp('****************************************************************************')


