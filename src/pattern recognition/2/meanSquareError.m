function [w, ww] = meanSquareError( data, nSample, dim)
%% mse算法 最小化 ||y - w'x||
%% 输入
% data 训练数据
% nSample 训练的个数，是一个向量（每个类的个数）
% dim 代表特征的个数
%
%% 输出
% w 线性分类结果 w'x = y;  (y 值为1，或-1)
% ww 带权重的，（y 值为 n1/n, -n2/n）
    
    %% 最小二乘流程
    n1 = nSample(1);
    n2 = nSample(2);
    n = n1 + n2;
    
    x = zeros(dim+1, n);
    y = zeros(n, 1);
    
    x(:, 1 : n1) = data{1, 1};
    x(:, n1+1 : n) = data{1, 2};
    
    %% 没有权重的情况
    y(1:n1, 1) = 1;
    y(n1+1 : n) = -1;
    
    % 最小二乘公式，伪逆
    w = inv(x * x') * x * y;
    
    %% 有权重的情况
    y(1:n1, 1) = n2 / n;
    y(n1+1 : n) = -n1 / n;
    
    % 最小二乘公式，伪逆
    ww = inv(x * x') * x * y;
  
end

