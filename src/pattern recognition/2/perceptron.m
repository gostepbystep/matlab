function [w, ws, miss] = perceptron( data, nSample, dim, alpha, nStep)
%% 感知机算法
%% 输入
% data 训练数据
% nSample 训练的个数，是一个向量（每个类的个数）
% dim 代表特征的个数
% alpha 迭代步长
% nStep 迭代次数
%
%% 输出
% w 线性分类结果 w'x = 0;  (x是增广向量)
% ws 迭代过程ws的变化情况
% miss 迭代过程中分错数的变化情况

    %% 初始化权重向量
    w = rand(dim+1, 1);
    ws = zeros(dim+1, nStep);
    miss = zeros(1, nStep);
    
    data1 = data{1, 1};
    data2 = data{1, 2};
    
    %% 感知机算法流程
    for i = 1 : nStep
        % 做第i次迭代
        ws(:, i) = w;                 % 存储当前w的值
        missNum = 0;
        
        % 第一类分错统计
        for k = 1 : nSample(1)
            % 遍历当前组的第k个实例
            x = data1(:, k);
            if(w' * x < 0)
                w = w + alpha * x;              % 修改w， 分错了x，（x属于第一类，本应该满足w'x > 0）
                missNum = missNum + 1;
            end
        end
        
        % 第二类分错统计
        for k = 1 : nSample(2)
            % 遍历当前组的第k个实例
            x = data2(:, k);
            if(w' * x > 0)
                w = w - alpha * x;
                missNum = missNum + 1;
            end
        end
        
        miss(i) = missNum;
    end
    
end

