function [ out ] = stpMinBFGSLinearEqual( func, A, xInit, B, iterNum )
%% bfgs algorithm for linear eqaul Ax = B;

    global globalA globalB threshold gloabalTheta globalx thresholdx;
    globalA = A;
    globalB = B;
    threshold = max(abs(B)) / 100;
    gloabalTheta = 0.7;
    
    out = stpMinBFGS(func, xInit, iterNum);

end

