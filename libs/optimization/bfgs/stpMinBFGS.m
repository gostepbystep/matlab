function [xOut] = stpMinBFGS( fun, x0, maxk) 
% ���ܣ���BFGS������Լ��������Сֵ 
%%
% ���룺
% x0�ǳ�ʼ�㣬
% fun��gfun�ֱ���Ŀ�꺯�����ݶ� 
%%
% �����x��val�ֱ������ŵ������ֵ��
% k�ǵ������� 
% ���������� 

    % ��ʼ������
    k = 0;
    eps = 10e-6; 
    n = length(x0); 
    
    % hessian����ĳ�ʼ��
    Bk = eye(n); 
    I = eye(n);

    xOut = x0;
    % ѭ��k��
    while (k < maxk) 
        % ��ȡһ�׵�����ֵ
        [fk, gk] = fun(x0);   
        
        curNorm = norm(gk);
        if(curNorm < eps)         
            break;     
        end 

        % ��ȡdk
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
        %BFGSУ�� 
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
 
