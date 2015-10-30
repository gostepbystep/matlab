clc;
clear;
close all;

%% svm ����
%% ������ʼ����
nSample = [200, 200, 150, 300, 200];   

% ��ά���
dim = 2;
coeff = {
        [-2.5 0.6;  2.5 0.8], ....
        [2.5 0.9;  2.5 0.7], ...
        [0 1.1; 0 1.3], ...
        [-2.5 0.7; -2.5 1.4], ...
        [2.5 1.3; -2.5 0.8]};
    
data = createSample(nSample, dim , coeff);

% % %% �ϲ���1 �� ��5��
% nSample = [400, 200, 150, 300]; 
% data{1} = [data{1}, data{5}];
% data = data(1 : 4);

%% �õ�ѵ������
nClass = length(nSample);

training_label_vector = [];
training_instance_matrix = [];

for i = 1 : nClass
    training_label_vector = [training_label_vector; i * ones(nSample(i), 1)];
    training_instance_matrix = [training_instance_matrix; data{i}'];
end

% Ԥ�����������ڵĽ��
xmin = -5; xmax = 5; ymin = -5; ymax = 5;
NX = 400; NY = 400;     % NY * NX ����

xs = linspace(xmin, xmax, NX);
ys = linspace(ymin, ymax, NY);
[xx, yy] = meshgrid(xs, ys);

nPixel = NX * NY;
label = ones(nPixel, 1);
val = [reshape(xx, nPixel,1), reshape(yy, nPixel, 1)];

%% svm �㷨
% model = libsvmtrain(training_label_vector, training_instance_matrix, '-c 2 -t 2');
% % Ԥ��
% [predict_label, accuracy, dec_values] = libsvmpredict(label, val, model);

%% bp�������㷨
[predict_label] = stpAnnBP(training_label_vector, training_instance_matrix, val, nClass);


%% ��ͼ
stpPaint2DResult(training_label_vector, training_instance_matrix, predict_label, NY, NX, xmin, xmax, ymin, ymax);


