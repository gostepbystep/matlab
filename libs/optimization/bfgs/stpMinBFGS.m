function [x] = stpMinBFGS( fun, gfun, x0, maxk) 
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
    rho = 0.5;
    sigma = 0.0001; 
    k = 0;
    eps = 10e-6; 
    v = 0.9;
    
    n = length(x0); 
    % hessian����ĳ�ʼ��
    Bk = eye(n); 
    I = eye(n);

    x = x0;
    % ѭ��k��
    while (k < maxk) 
        % ��ȡһ�׵�����ֵ
        gk = feval(gfun, x0);   
        curNorm = norm(gk);

        if(curNorm < eps)         
            break;     
        end 

        % ��ȡdk
        dk = -Bk * gk;  

       % Ѱ�ҵ�������
        m=0;    
        lamda = 1;        % ��ʼΪ rho^0

        old = feval(fun, x0); 
        delta = sigma * gk' * dk;
        while(m < 20)
            new = feval(fun, x0 + lamda*dk);

            if(new <= delta*lamda + old)       
                break;         
            end         

            m = m + 1;     
             % ����lamda��ʹ֮���ϱ�С
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
             % ����lamda��ʹ֮���ϱ�С
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
        %BFGSУ�� 
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
 
