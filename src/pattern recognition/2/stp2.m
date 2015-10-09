%% ģʽʶ��ڶ�����ҵ
% ���ߣ� �Ǳ�
% ѧ�ţ�201511010202
% ʱ�䣺2015-10-08 18:44

close all;
clear;
clc;

%% ������ʼ����
nSample = [400, 500];   
% ��ά���
dim = 3;
coeff = {
        [-1.1 0.8; -1.5 0.7; 1.4 -0.9;], ...
        [-1.7 1; 1.6 -0.6; -1.5 1.0;]};
    
% % ��ά���
% dim = 2;
% coeff = {
%         [2.0 0.8; -1.5 1.7;], ...
%         [-1.7 1; 1.3 -0.6;]};
    
data = createSample(nSample, dim , coeff);

%% ��֪���㷨
nStep = 201;
[wn1, ws, miss] = perceptron( data, nSample, dim, 0.001, nStep);

% ��֪���㷨��ͼ
subplot(1, 2, 1);
plot(1:nStep, miss);

subplot(1, 2, 2);
if dim == 2
    %% ��ά�������
    nout = 10;                      % ���10����
    iterval = floor(nStep / 10);
    % ���Ƶ������� Ȩ��w�ı仯���
    for i = 1 : nout
        wn1(:, i) = ws(:, (i-1)*iterval+1 );
    end
    
    if mod(nStep, 10) ~= 0
        wn1(:, nout+1) = ws(:, nStep);
    end
end
% ��ͼ
plotData( data, wn1, dim);

%% �������㷨
[wn2, ww] = meanSquareError( data, nSample, dim);
% ���������ͼ
figure;
% ��ͼ
wn2 = [wn2, ww];
plotData( data, wn2, dim);
title('mse�㷨');
legend(sprintf('%d��һ��', nSample(1)), sprintf('%d������', nSample(2)), '��𲻴�Ȩ�صĽ��', '����Ȩ�ؽ��');

%% svm �㷨
[ wn3, optval] = stpCvxSvm(data, nSample, dim, 1);
if optval == Inf
    fprintf('cvx�Ż�����\n');
else
    figure;
    plotData( data, wn3, dim);
    title('svm�㷨');
end
