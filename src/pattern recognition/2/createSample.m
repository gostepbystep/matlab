function [data] = createSample(nSample, dim, coeff)
%% 创建训练集合的函数
%% 输入
% nSample 训练的个数，是一个向量（每个类的个数）
% dim 代表特征的个数
% coeff 是生成训练结合的系数，是一个cell类型的
%
%% 输出
% 训练数据集合，一个cell类型

    [~, nGroup] = size(coeff);                                                       % the number of groups
    data = cell(1, nGroup);
    for i = 1 : nGroup
        curData = zeros(dim+1, nSample(i));                                            % create sample datas for data{i}
        curCoeff = coeff{i};

        for j = 1 : dim
            curData(j, :) = curCoeff(j, 1) + curCoeff(j, 2) * randn(1, nSample(i));  % the data distributed normally
        end
        curData(dim+1, :) = 1;
        
        data{i} = curData;
    end
end

