%% the homework 1 for pattern recognition
% author: She Bin
% time : 2015-09-22

clc;
close all;
clear;

%% initial some constant param.
nSample = [1000, 1000];           % the number of training samples for each group
dim = 3;
coeff = {
        [1.6 1.0; -1.5 1.0; 1.4 1.0;], ...
        [-1.7 1.0; 1.6 1.0; -1.5 1.0;]};
[~, nGroup] = size(coeff);      % the number of groups

%% create training samples
data = cell(1, nGroup);
for i = 1 : nGroup
    curData = zeros(dim, nSample(i));   % create sample datas for data{i}
    curCoeff = coeff{i};
    
    for j = 1 : dim
        curData(j, :) = curCoeff(j, 1) + curCoeff(j, 2) * randn(1, nSample(i));  % the data distributed normally
    end
    data{i} = curData;
end
% 
% save data data;
% load data;

%% show data
figure;
type = ['*', 'b'; 'o', 'm'];
for i = 1 : nGroup
    curData = data{i};
    plot3(curData(1, :), curData(2, :), curData(3, :), type(i, 1), 'LineWidth', 1,...
                'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
    hold on;
end
grid on;
axis equal;
axis([-5 5 -5 5 -5 5]);
title('蓝色表示一类， 紫红色表示二类')
legend('一类', '二类');

%% calculate some values
prior = zeros(1, nGroup);           % 1. prior probability
meanValue = zeros(dim, nGroup);     % 2. mean value
covData = cell(1, 2);               % 3. covariance matrix
sumSample = sum(nSample);

invCovData = cell(1, 2);
c = zeros(1, nGroup);

for i = 1 : nGroup
    prior(i) = nSample(i) / sumSample;
    meanValue(:, i) = sum(data{i}') / nSample(i);
    covData{i} = cov(data{i}');
    
    invCovData{i} = inv(covData{i});
    c(i) = log(prior(i)) + ( -dim/2 * log(2*pi) - 0.5*log(abs(det(covData{i}))) );
    fprintf('*****************************************************************\n');
    fprintf('%d. mean parameter value : [%f, %f, %f]\n', i, coeff{i}(:, 1));
    fprintf('%d. mean calculate value : [%f, %f, %f]\n', i, meanValue(:, i));
    fprintf('%d. covariance matrix : \n', i);
    disp(covData{i});
end

%% g(x)
global global_mean global_invCov globa_c;
global_mean = meanValue;
global_invCov = invCovData;
globa_c = c;
global global_x;

x1 = -5 : 0.1 : 5;
x2 = -5 : 0.1 : 5;
n1 = length(x1);
n2 = length(x2);
okNum = 1;

for i = 1 : n1
    i
    for j = 1 : n2
        global_x = [x1(i); x2(j); 0];
        [x3] = stpMinBFGS(@stpMinDecisionFunc, 0, 50);
        
        [error, ~] = stpMinDecisionFunc(x3);
        if(error < 1e-5 && x3>=-5 && x3<=5)
            result(okNum, :) = global_x;
            okNum = okNum + 1;
        end
    end
end

%% show the surface
figure;
type = ['*', 'b'; 'o', 'm'];
for i = 1 : nGroup
    curData = data{i};
    plot3(curData(1, :), curData(2, :), curData(3, :), type(i, 1), 'LineWidth', 1,...
                'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
    hold on;
end
grid on;
axis equal;
axis([-5 5 -5 5 -5 5]);
title('蓝色表示一类， 紫红色表示二类')
legend('一类', '二类');

hold on;
stpScatter(result);

