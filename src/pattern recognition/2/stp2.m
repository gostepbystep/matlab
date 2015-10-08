%% 模式识别第二次作业
% 作者： 厍斌
% 学号：201511010202
% 时间：2015-10-08 18:44

close all;
clear;
clc;

%% 创建初始数据
nSample = [1000, 100];   
% 三维情况
% dim = 3;
% coeff = {
%         [1.6 0.8; -1.5 0.7; 1.4 -0.9;], ...
%         [-1.7 1; 1.6 -0.6; -1.5 1.0;]};
    
% 二维情况
dim = 2;
coeff = {
        [1.6 0.8; -1.5 0.7;], ...
        [-1.7 1; 1.6 -0.6;]};
    
data = createSample(nSample, dim , coeff);

%% 感知机算法
nStep = 201;
[w, ws, miss] = perceptron( data, nSample, dim, 0.001, nStep);

%% 感知机算法绘图
subplot(1, 2, 1);
plot(1:nStep, miss);

 % 三维绘制代码
subplot(1, 2, 2);
type = ['*', 'b'; 'o', 'm'];
    
if dim == 3
    for i = 1 : 2
        curData = data{i};
        plot3(curData(1, :), curData(2, :), curData(3, :), type(i, 1), 'LineWidth', 1,...
                    'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
        hold on;
    end

    % 决策面
    x = -5 : 0.1 : 5;
    y = -5 : 0.1 : 5;
    [X, Y] = meshgrid(x, y);
    Z = (w(4) - w(1)*X - w(2)*Y) / w(3);
    surf(X, Y, Z);

    axis equal;
    axis([-5 5 -5 5 -5 5]);
else
    %% 二维绘制情况
    for i = 1 : 2
        curData = data{i};
        plot(curData(1, :), curData(2, :), type(i, 1), 'LineWidth', 1,...
                     'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
        hold on;
    end
    % 分界线
    x = -5 : 0.1 : 5;
    nout = 10;          % 输出10条线
    iterval = floor(nStep / 10);
    
    % 绘制迭代过程 权重w的变化情况
    startColor = [0.6, 1, 0.2];
    endColor = [1, 0.2, 0.3];
    for i = 1 : nStep
        if ( mod(i, iterval) == 0 || (i == nStep) || (i == 1) )
            w = ws(:, i);
            y = ( w(3) - w(1)*x ) / w(2);
            color = (nStep-i)/nStep * startColor + i/nStep * endColor;
            hold on;
            plot(x, y, 'Color', color, 'LineWidth', 1.3);
        end
    end
    axis([-5 5 -5 5]);
end

%% 均方差算法
[w, ww] = meanSquareError( data, nSample, dim);
% 均方差方法绘图
figure;
if dim == 3
    for i = 1 : 2
        curData = data{i};
        plot3(curData(1, :), curData(2, :), curData(3, :), type(i, 1), 'LineWidth', 1,...
                    'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
        hold on;
    end
    
    % 决策面
    x = -5 : 0.1 : 5;
    y = -5 : 0.1 : 5;
    [X, Y] = meshgrid(x, y);
    
    Z = (w(4) - w(1)*X - w(2)*Y) / w(3);
    surf(X, Y, Z);
    hold on;
    Z = (ww(4) - ww(1)*X - ww(2)*Y) / ww(3);
    surf(X, Y, Z);

    axis equal;
    axis([-5 5 -5 5 -5 5]);
else
    for i = 1 : 2
        curData = data{i};
        plot(curData(1, :), curData(2, :), type(i, 1), 'LineWidth', 1,...
                     'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
        hold on;
    end
    x = -5 : 0.1 : 5;
    y = ( w(3) - w(1)*x ) / w(2);
    plot(x, y, 'r');
    hold on;
    y = ( ww(3) - ww(1)*x ) / ww(2);
    plot(x, y, 'g');
    hold on;
    title('mse算法');
    legend(sprintf('%d个一类', nSample(1)), sprintf('%d个二类', nSample(2)), '类别不带权重的结果', '类别带权重结果');
end

   


