function [xOut] = stpMinBFGS( fun, x0, maxk) 
% 功能：用BFGS法求无约束问题最小值 
%%
% 输入：
% x0是初始点，
% fun和gfun分别是目标函数和梯度 
%%
% 输出：x、val分别是最优点和最优值，
% k是迭代次数 
% 最大迭代次数 

    % 初始化变量
    k = 0;
    eps = 10e-6; 
    n = length(x0); 
    
    % hessian矩阵的初始化
    Bk = eye(n); 
    I = eye(n);

    xOut = x0;
    % 循环k次
    while (k < maxk) 
        % 求取一阶导数的值
        [fk, gk] = fun(x0);   
        
        curNorm = norm(gk);
        if(curNorm < eps)         
            break;     
        end 

        % 求取dk
        dk = -Bk * gk;  
        
       %%
        % f(x+stp*s) <= f(x) + ftol*stp*(gradf(x)'s),
        % abs(gradf(x+stp*s)'s)) <= gtol*abs(gradf(x)'s).
        %
        %     function [x,f,g,stp,info,nfev] ...
        %        = cvsrch(fcn,n,x,f,g,s,stp,ftol,gtol,xtol, ...
        %                  stpmin,stpmax,maxfev)
        [xOut, ~, gnew, ~, ~, ~] ...
           = cvsrch(@stpHubberFunc, n, x0,  fk, gk, dk, 1, 0.0001, ...
                    0.9, 1e-8,0, inf, 20);

       %%
        %BFGS校正 
        sk = xOut - x0; 
        yk = gnew - gk;   

        coffk = 1 / (yk' * sk);
        Vk = I - coffk * yk * sk';

        condition = yk' * sk;
        if(condition ~= 0) 
            %Bk = Bk-(((Bk * sk')*sk)*Bk)/(sk*Bk*sk')+(yk'*yk)/(yk*sk');     
            Bk = Vk' * Bk * Vk + coffk * sk * sk';
        end     

        k = k + 1;     
        x0 = xOut; 
    end
end 
 
