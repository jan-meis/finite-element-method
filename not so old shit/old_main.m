
% forgot that i can just integrate that analytically:
% referenceIntegral = 0;
% referenceIntegralMat = referenceSolution;
% referenceIntegralMat(2:end-1, :) = 2*referenceIntegralMat(2:end-1, :);
% referenceIntegralMat(:, 2:end-1) = 2*referenceIntegralMat(:, 2:end-1);
% for i = 0:100
%     for j = 0:100
%         referenceIntegral = referenceIntegral + referenceIntegralMat(i+1, j+1);
%     end
% end
% referenceIntegral = referenceIntegral * 0.25* (1/100.0)^2;





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
