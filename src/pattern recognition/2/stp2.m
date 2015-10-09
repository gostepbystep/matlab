%% ģʽʶ��ڶ�����ҵ
% ���ߣ� �Ǳ�
% ѧ�ţ�201511010202
% ʱ�䣺2015-10-08 18:44

close all;
clear;
clc;

%% ������ʼ����
nSample = [1000, 1000];   
% ��ά���
dim = 3;
coeff = {
        [1.1 0.8; -1.5 0.7; 1.4 -1;], ...
        [-1.7 1; 1.6 -1.2; -1.5 1.1;]};
%     
% ��ά���
% dim = 2;
% coeff = {
%         [2.0 1.7; -1.8 1.1;], ...
%         [-1.9 1.8; 1.9 -1.7;]};
%     
data = createSample(nSample, dim , coeff);

%% ��֪���㷨
nStep = 201;
[wn1, ws, miss] = perceptron( data, nSample, dim, 1, nStep);

% ��֪���㷨��ͼ
subplot(1, 2, 1);
plot(1:nStep, miss);
title('�ִ�����仯ͼ');

swn1 = wn1;
subplot(1, 2, 2);
if dim == 2
    %% ��ά�������
    nout = 10;                      % ���10����
    iterval = floor(nStep / 10);
    % ���Ƶ������� Ȩ��w�ı仯���
    for i = 1 : nout
        swn1(:, i) = ws(:, (i-1)*iterval+1 );
    end
    
    if mod(nStep, 10) ~= 0
        swn1(:, nout+1) = ws(:, nStep);
    end
end
% ��ͼ
plotData( data, swn1, dim);
title('��֪�����Է�����');

%% �������㷨s
[wn2, ww] = meanSquareError( data, nSample, dim);
% ���������ͼ
figure;
% ��ͼ
w1 = wn2;   w1(dim+1) = w1(dim+1) - 1;
w2 = wn2;   w2(dim+1) = w2(dim+1) + 1;
w3 = ww;   w3(dim+1) = w3(dim+1) - nSample(2)/(nSample(1) + nSample(2)) ;
w4 = ww;   w4(dim+1) = w4(dim+1) + nSample(1)/(nSample(1) + nSample(2)) ;
swn2 = [wn2, ww, w1, w2, w3, w4];
plotData( data, swn2, dim);
title('mse�㷨');
legend(sprintf('%d��һ��', nSample(1)), sprintf('%d������', nSample(2)), ...
    '��𲻴�Ȩ�صĽ��', '����Ȩ�ؽ��' ...
    , '����Ȩ��һ�����', '����Ȩ�ض������', '��Ȩ��һ�����', '��Ȩ�ض������');
% legend(sprintf('%d��һ��', nSample(1)), sprintf('%d������', nSample(2)), '��𲻴�Ȩ�صĽ��', '����Ȩ�ؽ��');

%% svm �㷨
[ wn3, optval] = stpCvxSvm(data, nSample, dim, 2);
if optval == Inf
    fprintf('cvx�Ż�����\n');
else
    figure;
    w1 = wn3;       w1(dim+1) = w1(dim+1) - 1;         % һ��߽�
    w2 = wn3;       w2(dim+1) = w2(dim+1) + 1;         % ����߽�
    
    swn3 = [wn3, w1, w2];
    
    plotData( data, swn3, dim);
    legend(sprintf('%d��һ��', nSample(1)), sprintf('%d������', nSample(2)), ...
        'svm�㷨������', 'һ��֧������', '����֧������');
    title('svm�㷨');
end

%% �����㷨�Ƚ�
figure;
swn4 = [wn1, wn2, wn3];
plotData( data, swn4, dim);
legend(sprintf('%d��һ��', nSample(1)), sprintf('%d������', nSample(2)), ...
    '��֪���㷨', 'MSE��С�����㷨', 'svm�㷨');
title('�����㷨�Ա�');