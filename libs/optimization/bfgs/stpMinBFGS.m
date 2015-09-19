function [x] = stpMinBFGS( fun, gfun, x0, maxk) 
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
    rho = 0.5;
    sigma = 0.0001; 
    k = 0;
    eps = 10e-6; 
    v = 0.9;
    
    n = length(x0); 
    % hessian矩阵的初始化
    Bk = eye(n); 
    I = eye(n);

    x = x0;
    % 循环k次
    while (k < maxk) 
        % 求取一阶导数的值
        gk = feval(gfun, x0);   
        curNorm = norm(gk);

        if(curNorm < eps)         
            break;     
        end 

        % 求取dk
        dk = -Bk * gk;  

       % 寻找迭代步长
        m=0;    
        lamda = 1;        % 初始为 rho^0

        old = feval(fun, x0); 
        delta = sigma * gk' * dk;
        while(m < 20)
            new = feval(fun, x0 + lamda*dk);

            if(new <= delta*lamda + old)       
                break;         
            end         

            m = m + 1;     
             % 更新lamda，使之不断变小
            lamda = lamda * rho;
        end 

        old = abs(v * gk' * dk);
        m = 0;
        while(m < 20)
            gnew = feval(gfun, x0 + lamda*dk);
            new = abs( gnew' * dk);

            if(new <= old)       
                break;         
            end         

            m = m + 1;     
             % 更新lamda，使之不断变小
            lamda = lamda * rho;
        end 

%%
% f(x+stp*s) <= f(x) + ftol*stp*(gradf(x)'s),
% abs(gradf(x+stp*s)'s)) <= gtol*abs(gradf(x)'s).
%     function [x,f,g,stp,info,nfev] ...
%        = cvsrch(fcn,n,x,f,g,s,stp,ftol,gtol,xtol, ...
%                  stpmin,stpmax,maxfev)
%             [x, f, g, rho, info,nfev] ...
%        = cvsrch('stpHubberFcn', n, x0, feval(fun, x0), ...
%             feval(gfun, x0), dk, 1, 0.0001, 0.9, 1e-8, ...
%                  0, inf, 20);

%            alpha =  mb_nocLineSearch(@stpHubberFunc, @stpHubberGFunc, x0, dk, gk'*dk, feval(fun, x0));

%%
        %BFGS校正 
        x = x0 + lamda * dk;     
        sk = x - x0; 
        yk = feval(gfun, x) - gk;   

        coffk = 1 / (yk' * sk);
        Vk = I - coffk * yk * sk';


        condition = yk' * sk;

        if(condition ~= 0) 
            %Bk = Bk-(((Bk * sk')*sk)*Bk)/(sk*Bk*sk')+(yk'*yk)/(yk*sk');     
            Bk = Vk' * Bk * Vk + coffk * sk * sk';
        end     

        k = k + 1;     
        x0 = x; 
    end
end 
 
