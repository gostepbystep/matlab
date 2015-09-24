%% BBS
clear;
close all;
clc;

%% 初始化
N = 3;
M = 3;

%% 载入图像
path = 'E:\picture\cvx\bbs\';
name = ['1.wav'; '2.wav'; '3.wav'];

sdata = cell(1, N);
for i = 1 : N
    [sdata{i}, Fs, bits] = wavread([path, name(i, :)]);
     
end

% 转换为s
[m, n] = size(sdata{1});
L = floor(m * n);
s = zeros(L, N);

for i = 1 : N
    [mm, nn] = size(sdata{i});
    temp = reshape(sdata{i}, mm*nn, 1);
    s(:, i) = temp(1:L, 1);
    
    sdata{i} = reshape(s(:, i), m, n);
    s(:, i) = s(:, i) + 10;
    
    % 保存源
    wavwrite(sdata{i}, Fs, bits, [path, 's', name(i, :)]);
end

%% 生成新的图片
% x = zeros(L, M);
A = [0.4, 0.2, 0.4;
     0.3, 0.3, 0.4; 
     0.2, 0.4, 0.4];
A = A';
x = s * A;

xdata = cell(1, M);
for i = 1 : M
    xdata{i} = reshape(x(:, i)-10, m, n);
    wavwrite(xdata{i}, Fs, bits, [path, 'x', name(i, :)]);
end


% 解答
[ sout ] = stpCAMNS( x );
sout = sout - 10;
soutData = cell(1, N);
for i = 1 : M
    soutData{i} = reshape(sout(:, i)-10, m, n);
    wavwrite(soutData{i}, Fs, bits, [path, 'out', name(i, :)]);
end


