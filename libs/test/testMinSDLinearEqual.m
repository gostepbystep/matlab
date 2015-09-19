%% test the function of stpMinSDLinearEqual

clc;
close all;
clear;

m = 1000;
n = 400;

% create random data
A = round(8 * rand(m, n));
x = round( 100 * randn(n, 1) );
x0 = round( 10 * rand(n, 1) );

% B = A * x
B = A * x;

fprintf('\ttest the function of stpMinSDLinearEqual\n');

% call steepest descent function
out = stpMinSDLinearEqual(A, x0, B, 500, false);

fprintf('\tthe norm of error is %d\n', norm(out-x) );


