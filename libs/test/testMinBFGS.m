clc;
close all;
clear;

% 测试bfgs的程序
% m = 10000;
% n = 150;
% A = round(8 * rand(m, n));
% xn = round( 100 * randn(n, 1) );
% x0 = round( 100 * rand(n, 1) );
% B = A * xn;

% save testMinBFGSData A xn x0;
% load testMinBFGSData;

% load the sesmic data
load realSesmicData;

th = max(abs(B)) / 100;
global globalA globalB threshold;
globalA = A;
globalB = B;
threshold = th;
x0 = xn;
    
figure;
iterNum = 100;

out1 = stpMinBFGS('stpHubberFunc', 'stpHubberGFunc', x0, iterNum);
dd1 = A*out1 - B;
stpHist(dd1, 'r');

% out2 = stpMinBFGS( 'stpOneNormFunc', 'stpOneNormGFunc', x0, iterNum);
% dd2 = A*out2 - B;
% hold on;
% stpHist(dd2, 'g');
% 
% global gloabalTheta;
% 
% gloabalTheta = 0;
% out3 = stpMinBFGS('stpCombMixFunc', 'stpCombMixGFunc', x0, iterNum);
% dd3 = A*out3 - B;
% hold on;
% stpHist(dd3, 'b');
% 
% gloabalTheta = 0.4;
% out4 = stpMinBFGS( 'stpCombMixFunc', 'stpCombMixGFunc', x0, iterNum);
% dd4 = A*out4 - B;
% hold on;
% stpHist(dd4, 'black');
% 
% legend('Hubber混合', '一阶范数', '二阶范数', sprintf('混合范数theta:%d', gloabalTheta));