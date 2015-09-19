function [ xOut ] = stpMinGradientDescent( fun, x0, iterNum, alpha, quiet)
%% the algorithm of gradient descent
%
%% input
% fun : such as [f, g] = fun(x)
% x0 : the initial x
% iterNum : the number of iteration
% alpha : the param for this algorithm
% quiet : if print the info about each iteration
%
%% output
% xOut : the result of iterations
    xOut = x0;

    RMSE = zeros(1, iterNum);
    
    for i = 1 : iterNum
        [f, g] = fun(xOut);
        
%         lamda = 100;
%         for j = 1 : 40
%             [fk, ~] = fun(xOut - lamda * g);
%             if( fk < f)
%                 break;
%             end
%             lamda = lamda * 0.5;
%         end
        
        e = alpha * g;
        xOut = xOut - e;
        
        RMSE(i) = sqrt( mse(e) );
        
        if( i> 2 && abs ( RMSE(i) - RMSE(i-1)) < 1e-8)
            break;
        end
    end

    if(~quiet)
        figure; 
        plot(RMSE(2:iterNum)); 
        grid on; 
        title('MES: error of mean square');
    end
end

