function [xOut] = stpMinSDLinearEqual(A, xInit, B, iterNum, quiet)
%% steepest descent method. 
% for solving min(AX-B)'(Ax-B)
%
% input
% A : matrix A
% xInit : initial vector varibles x
% B : vector B
% iterNum : the number of iteration
% quiet : is print the process.
%
% output
% xOut : after iterations, the algorithm's output.

    xOut = xInit;
    
    AA = A' * A;
    AB = A' * B;

    RMSE = zeros(1, length(xInit));
    
    for i = 1 : iterNum
        e = A * xOut - B;
        dr = AA * xOut - AB;
        alpha = e' * A * dr / (dr' * AA * dr);      %adaptive stepsize
        xOut = xOut - alpha * dr;
        
        if(~quiet)
            RMSE(i) = sqrt( mse(e) );
        end
    end
    
    if(~quiet)
        figure; 
        plot(RMSE(2:iterNum)); 
        grid on; 
        title('MES: error of mean square');
    end
    
end