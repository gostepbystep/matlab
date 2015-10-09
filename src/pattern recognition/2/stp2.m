%% 模式识别第二次作业
% 作者： 厍斌
% 学号：201511010202
% 时间：2015-10-08 18:44

close all;
clear;
clc;

%% 创建初始数据
nSample = [400, 500];   
% 三维情况
dim = 3;
coeff = {
        [-1.1 0.8; -1.5 0.7; 1.4 -0.9;], ...
        [-1.7 1; 1.6 -0.6; -1.5 1.0;]};
    
% % 二维情况
% dim = 2;
% coeff = {
%         [2.0 0.8; -1.5 1.7;], ...
%         [-1.7 1; 1.3 -0.6;]};
    
data = createSample(nSample, dim , coeff);

%% 感知机算法
nStep = 201;
[wn1, ws, miss] = perceptron( data, nSample, dim, 0.001, nStep);

% 感知机算法绘图
subplot(1, 2, 1);
plot(1:nStep, miss);

subplot(1, 2, 2);
if dim == 2
    %% 二维绘制情况
    nout = 10;                      % 输出10条线
    iterval = floor(nStep / 10);
    % 绘制迭代过程 权重w的变化情况
    for i = 1 : nout
        wn1(:, i) = ws(:, (i-1)*iterval+1 );
    end
    
    if mod(nStep, 10) ~= 0
        wn1(:, nout+1) = ws(:, nStep);
    end
end
% 绘图
plotData( data, wn1, dim);

%% 均方差算法
[wn2, ww] = meanSquareError( data, nSample, dim);
% 均方差方法绘图
figure;
% 绘图
wn2 = [wn2, ww];
plotData( data, wn2, dim);
title('mse算法');
legend(sprintf('%d个一类', nSample(1)), sprintf('%d个二类', nSample(2)), '类别不带权重的结果', '类别带权重结果');

%% svm 算法
[ wn3, optval] = stpCvxSvm(data, nSample, dim, 1);
if optval == Inf
    fprintf('cvx优化错误\n');
else
    figure;
    plotData( data, wn3, dim);
    title('svm算法');
end
