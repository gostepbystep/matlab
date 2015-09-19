clc;
close all;
clear;

% 测试bfgs的程序
% m = 10000;
% n = 150;
% A = round(8 * rand(m, n));
% xn = round( 100 * randn(n, 1) );
% x0 = round( 100 * rand(n, 1) );


% save testMinBFGSData A xn x0;
load testMinBFGSData;
B = A * xn;

% load the sesmic data
% load realSesmicData;

th = max(abs(B)) / 1000;
global globalA globalB threshold;
globalA = A;
globalB = B;
threshold = th;
% x0 = xn;
    
figure;
iterNum = 50;

out1 = stpMinBFGS(@stpHubberFunc, x0, iterNum);
% out1 = stpMinSDLinearEqual(A, x0, B, iterNum, false);
dd1 = A*out1 - B;
stpHist(dd1, 'r');

% out2 = stpMinBFGS(@stpOneNormFunc, x0, iterNum);
% dd2 = A*out2 - B;
% hold on;
% stpHist(dd2, 'g');
% 
% global gloabalTheta;
% 
% gloabalTheta = 0;
% out3 = stpMinBFGS(@stpCombMixFunc, x0, iterNum);
% dd3 = A*out3 - B;
% hold on;
% stpHist(dd3, 'b');
% 
% gloabalTheta = 0.4;
% out4 = stpMinBFGS( @stpCombMixFunc, x0, iterNum);
% dd4 = A*out4 - B;
% hold on;
% stpHist(dd4, 'black');
% 
% legend('Hubber混合', '一阶范数', '二阶范数', sprintf('混合范数theta:%d', gloabalTheta));