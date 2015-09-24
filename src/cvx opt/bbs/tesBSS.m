%% BBS
clear;
close all;
clc;

%% 初始化
N = 3;
M = 3;

%% 载入图像
path = 'E:\picture\cvx\bbs\';
name = ['1.jpg'; '2.jpg'; '3.jpg'];

sdata = cell(1, N);
for i = 1 : N
    sdata{i} = loadPicture([path, name(i, :)]);
end

% 转换为s
[m, n, rgb] = size(sdata{1});
L = m * n * rgb;
s = zeros(L, N);

for i = 1 : N
    s(:, i) = reshape(sdata{i}, L, 1);
end

%% 生成新的图片
% x = zeros(L, M);
A = [0.5, 0.2, 0.3;
     0.2, 0.6, 0.2; 
     0.1, 0.4, 0.5];
A = A';
x = s * A;
x = uint8(x);

xdata = cell(1, M);
for i = 1 : M
    xdata{i} = reshape(x(:, i), m, n, rgb);
end

% 解答
[ sout ] = stpCAMNS( x );
sout = uint8(sout);
soutData = cell(1, N);
for i = 1 : M
    soutData{i} = reshape(sout(:, i), m, n, rgb);
end

% 画图
figure;
for i = 1 : N
    subplot(3, N, i);       imshow(sdata{i});
    subplot(3, N, i+N);       imshow(xdata{i});
    subplot(3, N, i+N*2);       imshow(soutData{i});
end

