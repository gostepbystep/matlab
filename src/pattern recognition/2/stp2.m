%% ģʽʶ��ڶ�����ҵ
% ���ߣ� �Ǳ�
% ѧ�ţ�201511010202
% ʱ�䣺2015-10-08 18:44

close all;
clear;
clc;

%% ������ʼ����
nSample = [1000, 100];   
% ��ά���
% dim = 3;
% coeff = {
%         [1.6 0.8; -1.5 0.7; 1.4 -0.9;], ...
%         [-1.7 1; 1.6 -0.6; -1.5 1.0;]};
    
% ��ά���
dim = 2;
coeff = {
        [1.6 0.8; -1.5 0.7;], ...
        [-1.7 1; 1.6 -0.6;]};
    
data = createSample(nSample, dim , coeff);

%% ��֪���㷨
nStep = 201;
[w, ws, miss] = perceptron( data, nSample, dim, 0.001, nStep);

%% ��֪���㷨��ͼ
subplot(1, 2, 1);
plot(1:nStep, miss);

 % ��ά���ƴ���
subplot(1, 2, 2);
type = ['*', 'b'; 'o', 'm'];
    
if dim == 3
    for i = 1 : 2
        curData = data{i};
        plot3(curData(1, :), curData(2, :), curData(3, :), type(i, 1), 'LineWidth', 1,...
                    'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
        hold on;
    end

    % ������
    x = -5 : 0.1 : 5;
    y = -5 : 0.1 : 5;
    [X, Y] = meshgrid(x, y);
    Z = (w(4) - w(1)*X - w(2)*Y) / w(3);
    surf(X, Y, Z);

    axis equal;
    axis([-5 5 -5 5 -5 5]);
else
    %% ��ά�������
    for i = 1 : 2
        curData = data{i};
        plot(curData(1, :), curData(2, :), type(i, 1), 'LineWidth', 1,...
                     'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
        hold on;
    end
    % �ֽ���
    x = -5 : 0.1 : 5;
    nout = 10;          % ���10����
    iterval = floor(nStep / 10);
    
    % ���Ƶ������� Ȩ��w�ı仯���
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

%% �������㷨
[w, ww] = meanSquareError( data, nSample, dim);
% ���������ͼ
figure;
if dim == 3
    for i = 1 : 2
        curData = data{i};
        plot3(curData(1, :), curData(2, :), curData(3, :), type(i, 1), 'LineWidth', 1,...
                    'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
        hold on;
    end
    
    % ������
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
    title('mse�㷨');
    legend(sprintf('%d��һ��', nSample(1)), sprintf('%d������', nSample(2)), '��𲻴�Ȩ�صĽ��', '����Ȩ�ؽ��');
end

   


