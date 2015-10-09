%% 模式识别第二次作业
% 作者： 厍斌
% 学号：201511010202
% 时间：2015-10-08 18:44

close all;
clear;
clc;

%% 创建初始数据
nSample = [1000, 1000];   
% 三维情况
dim = 3;
coeff = {
        [1.1 0.8; -1.5 0.7; 1.4 -1;], ...
        [-1.7 1; 1.6 -1.2; -1.5 1.1;]};
%     
% 二维情况
% dim = 2;
% coeff = {
%         [2.0 1.7; -1.8 1.1;], ...
%         [-1.9 1.8; 1.9 -1.7;]};
%     
data = createSample(nSample, dim , coeff);

%% 感知机算法
nStep = 201;
[wn1, ws, miss] = perceptron( data, nSample, dim, 1, nStep);

% 感知机算法绘图
subplot(1, 2, 1);
plot(1:nStep, miss);
title('分错次数变化图');

swn1 = wn1;
subplot(1, 2, 2);
if dim == 2
    %% 二维绘制情况
    nout = 10;                      % 输出10条线
    iterval = floor(nStep / 10);
    % 绘制迭代过程 权重w的变化情况
    for i = 1 : nout
        swn1(:, i) = ws(:, (i-1)*iterval+1 );
    end
    
    if mod(nStep, 10) ~= 0
        swn1(:, nout+1) = ws(:, nStep);
    end
end
% 绘图
plotData( data, swn1, dim);
title('感知机线性分类器');

%% 均方差算法s
[wn2, ww] = meanSquareError( data, nSample, dim);
% 均方差方法绘图
figure;
% 绘图
w1 = wn2;   w1(dim+1) = w1(dim+1) - 1;
w2 = wn2;   w2(dim+1) = w2(dim+1) + 1;
w3 = ww;   w3(dim+1) = w3(dim+1) - nSample(2)/(nSample(1) + nSample(2)) ;
w4 = ww;   w4(dim+1) = w4(dim+1) + nSample(1)/(nSample(1) + nSample(2)) ;
swn2 = [wn2, ww, w1, w2, w3, w4];
plotData( data, swn2, dim);
title('mse算法');
legend(sprintf('%d个一类', nSample(1)), sprintf('%d个二类', nSample(2)), ...
    '类别不带权重的结果', '类别带权重结果' ...
    , '不带权重一类拟合', '不带权重二类拟合', '带权重一类拟合', '带权重二类拟合');
% legend(sprintf('%d个一类', nSample(1)), sprintf('%d个二类', nSample(2)), '类别不带权重的结果', '类别带权重结果');

%% svm 算法
[ wn3, optval] = stpCvxSvm(data, nSample, dim, 2);
if optval == Inf
    fprintf('cvx优化错误\n');
else
    figure;
    w1 = wn3;       w1(dim+1) = w1(dim+1) - 1;         % 一类边界
    w2 = wn3;       w2(dim+1) = w2(dim+1) + 1;         % 二类边界
    
    swn3 = [wn3, w1, w2];
    
    plotData( data, swn3, dim);
    legend(sprintf('%d个一类', nSample(1)), sprintf('%d个二类', nSample(2)), ...
        'svm算法分类结果', '一类支持向量', '二类支持向量');
    title('svm算法');
end

%% 三种算法比较
figure;
swn4 = [wn1, wn2, wn3];
plotData( data, swn4, dim);
legend(sprintf('%d个一类', nSample(1)), sprintf('%d个二类', nSample(2)), ...
    '感知机算法', 'MSE最小二乘算法', 'svm算法');
title('三种算法对比');