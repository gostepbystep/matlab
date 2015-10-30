clc;
clear;
close all;

%% svm 分类
%% 创建初始数据
nSample = [200, 200, 150, 300, 200];   

% 三维情况
dim = 2;
coeff = {
        [-2.5 0.6;  2.5 0.8], ....
        [2.5 0.9;  2.5 0.7], ...
        [0 1.1; 0 1.3], ...
        [-2.5 0.7; -2.5 1.4], ...
        [2.5 1.3; -2.5 0.8]};
    
data = createSample(nSample, dim , coeff);

% % %% 合并第1 和 第5类
% nSample = [400, 200, 150, 300]; 
% data{1} = [data{1}, data{5}];
% data = data(1 : 4);

%% 得到训练数据
nClass = length(nSample);

training_label_vector = [];
training_instance_matrix = [];

for i = 1 : nClass
    training_label_vector = [training_label_vector; i * ones(nSample(i), 1)];
    training_instance_matrix = [training_instance_matrix; data{i}'];
end

% 预测整个方块内的结果
xmin = -5; xmax = 5; ymin = -5; ymax = 5;
NX = 400; NY = 400;     % NY * NX 像素

xs = linspace(xmin, xmax, NX);
ys = linspace(ymin, ymax, NY);
[xx, yy] = meshgrid(xs, ys);

nPixel = NX * NY;
label = ones(nPixel, 1);
val = [reshape(xx, nPixel,1), reshape(yy, nPixel, 1)];

%% svm 算法
% model = libsvmtrain(training_label_vector, training_instance_matrix, '-c 2 -t 2');
% % 预测
% [predict_label, accuracy, dec_values] = libsvmpredict(label, val, model);

%% bp神经网络算法
[predict_label] = stpAnnBP(training_label_vector, training_instance_matrix, val, nClass);


%% 画图
stpPaint2DResult(training_label_vector, training_instance_matrix, predict_label, NY, NX, xmin, xmax, ymin, ymax);


