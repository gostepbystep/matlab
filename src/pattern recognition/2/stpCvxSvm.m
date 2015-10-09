function [ out, cvx_optval] = stpCvxSvm(data, nSample, dim, type)
%% svm 的优化求解，使用cvx工具箱
% min ||w|| s.t. y .* (w' * x) >= 1 (x 是增广向量)
%
%% 输入
% data 训练数据
% nSample 训练的个数，是一个向量（每个类的个数）
% dim 代表特征的个数
% type  表示svm类型，如果为1表示训练集完全可分，否则不可分
%
%% 输出
% out 线性分类结果 out'x = y;  (y 值为1，或-1)
% cvx_optval cvx输出结果

    %% 初始化数据
    n1 = nSample(1);
    n2 = nSample(2);
    n = n1 + n2;
    
    x = zeros(dim+1, n);
    y = zeros(n, 1);
    
    x(:, 1 : n1) = data{1, 1};
    x(:, n1+1 : n) = data{1, 2};
    
    y(1:n1, 1) = 1;
    y(n1+1 : n) = -1;
    
    %% 核心代码，调用cvx工具箱，优化该QP问题
    if type == 1
        cvx_begin
        variable w(dim+1, 1);
        
        minimize( norm(w, 2));
        subject to
            y .* (x' * w) >= 1;
        cvx_end
    else
        cvx_begin
        variables w(dim+1, 1) rho(n);
        
        minimize( norm(w, 2) + 1 * sum(rho) );
        subject to
            y .* (x' * w) >= 1 - rho;
            rho >= 0;
        cvx_end
    end
    
    
    out = w;
end

