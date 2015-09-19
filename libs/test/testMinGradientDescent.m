%% test the function of stpMinGradientDescent

clc;
close all;
clear;

m = 5000;
n = 500;

% create random data
A = round(8 * rand(m, n));
x = round( 100 * randn(n, 1) );
x0 = round( 10 * rand(n, 1) );

% B = A * x
B = A * x;

fprintf('\ttest the function of stpMinGradientDescent\n');

% call steepest descent function
th = max(abs(B)) / 100;
global globalA globalB threshold;
globalA = A;
globalB = B;
threshold = th;
out = stpMinGradientDescent(@stpHubberFunc, x0, 500, 0.1, false);

fprintf('\tthe norm of error is %d\n', norm(out-x) );


