%******   main   ******

%clear command Window, variables and figures
clc
clear variables
close all
%add subfolders to PATH
addpath(genpath(pwd))

neumann = false; %dirichlet boundary conditions
minMeshRefinement = 1;
maxMeshRefinement = 6;

%calculate reference solution for comparison with approximate solutions
referenceSolution = zeros(101);
for i = 0:100
    for j = 0:100
        referenceSolution(i+1, j+1) = exactSolution_sinsin(i/100.0, j/100.0);
    end
end
%analytically integrated:
referenceIntegral = 2 / pi^4;

alltime = tic;
disp(['Starting computations for meshes with 1 to ' num2str(maxMeshRefinement) ' subdivisions:'])
disp(' ')
for numSubintervals = minMeshRefinement:maxMeshRefinement
    
    starttime = tic;
    disp('****************************************************************************')
    disp(['Starting compution for ' num2str(numSubintervals) ' subintervals:'])
    
    disp(' ')
    
    tic
    disp('Creating mesh...')
    %mesh configurations: square mesh with numSubintervals^2 squares
    mesh = create_mesh_squares(numSubintervals);
    edges = edge.empty();
    for i = 1:size(mesh, 2)
        p1 = mesh(i);
        for j = i+1:size(mesh, 2)
            p2 = mesh(j);
            ids=[];
            for d1=p1.domains(1:end)
                for d2 = p2.domains(1:end)
                    if (d1 == d2)
                        ids(end+1) = d1.ID;
                    end
                    if (size(ids, 2) ==2)
                        edges(end+1) = edge(p1.x, p2.x, p1.y, p2.y, ids(1), ids(2));
                    end
                end
            end
        end
    end
    maxID=0;
    for p = mesh(1:end)
        for d = p.domains(1:end)
            maxID = max(maxID, d.ID);
        end
    end
    faces = square.empty(maxID+1, 0);
    for i = 0:maxID
        loopctrl=false;
        for p = mesh(1:end)
            for d = p.domains(1:end)
                if (d.ID==i)
                    faces(end+1) = square(min(d.x1, d.x3),  max(d.x1, d.x3), max(d.x1, d.x3), min(d.x1, d.x3), min(d.y1, d.y3), min(d.y1, d.y3), max(d.y1, d.y3), max(d.y1, d.y3), i);
                    loopctrl=true;
                end
                if (loopctrl)
                    break;
                end
            end
            if (loopctrl)
                break;
            end
        end
    end
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
    facefunctions = polynomial.empty(maxID, 0);
    for i = 0:maxID
        poly = polynomial(0);
        for j = 1:size(basisfunctions, 2)
            phi = basisfunctions(j);
            for shape = phi.shapefunctions(1:end)
                if (shape.domain.ID == i)
                    poly = poly + polynomial(coefficients(j) * shape.poly.XY);
                end
            end
        end
        facefunctions(end+1) = poly;
    end
    
    edgegradients = vectorfield.empty(size(edges, 2), 0);
    for currentEdge = edges(1:end)
        pol = facefunctions(currentEdge.id1 +1) - facefunctions(currentEdge.id2 +1);
        edgegradients(end+1) = pol.gradient();
    end
    edgeTerm = 0;
    for i = 1:size(edges, 2)
        currentEdge = edges(i);
        edgegrad = edgegradients(i);
        normvec = vectorfield(constantfunction(-currentEdge.y1 + currentEdge.y2 ), constantfunction(currentEdge.x1 - currentEdge.x2));
        fun = scalarfunction(wrapper_squared(wrapper_vectimesvec(edgegrad, normvec)));
        edgeContrib = sqrt((currentEdge.x1- currentEdge.x2)^2 + (currentEdge.y1 - currentEdge.y2)^2)*T1D(fun, linspace(currentEdge.x1, currentEdge.x2, 15), linspace(currentEdge.y1, currentEdge.y2, 15));
        edgeTerm = edgeTerm + edgeContrib;
    end
    edgeTerm = edgeTerm/2;
    
    faceTerm =0;
    for i = 1:size(faces, 2)
        face = faces(i);
        facefun = facefunctions(i);
        diamSquared = (face.x1 - face.x3)^2 + (face.y1 - face.y3)^2;
        fun = wrapper_squared(wrapper_polyplusfunc(facefun.laplace(), @sinsin));
        faceContrib = diamSquared * T2D(fun, linspace(face.x1, face.x3, 15), linspace(face.y1, face.y3, 15));
        faceTerm = faceTerm + faceContrib;
    end
    aposteriorierror = sqrt(edgeTerm + faceTerm);
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
    disp(['finished calculating maximum absolute errors: ' num2str(max(max(abserrormat)))])
    disp(['finished calculating average absolute error: ' num2str(abserror)])
    disp(['finished calculating relative error in L2 norm: ' num2str(relerror)])
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
disp(' ')
disp('everything finished!')
toc(alltime)

