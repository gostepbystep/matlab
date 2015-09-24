%% BBS
clear;
close all;
clc;

%% ��ʼ��
N = 3;
M = 3;

%% ����ͼ��
path = 'E:\picture\cvx\bbs\';
name = ['1.jpg'; '2.jpg'; '3.jpg'];

sdata = cell(1, N);
for i = 1 : N
    sdata{i} = loadPicture([path, name(i, :)]);
end

% ת��Ϊs
[m, n, rgb] = size(sdata{1});
L = m * n * rgb;
s = zeros(L, N);

for i = 1 : N
    s(:, i) = reshape(sdata{i}, L, 1);
end

%% �����µ�ͼƬ
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

% ���
[ sout ] = stpCAMNS( x );
sout = uint8(sout);
soutData = cell(1, N);
for i = 1 : M
    soutData{i} = reshape(sout(:, i), m, n, rgb);
end

% ��ͼ
figure;
for i = 1 : N
    subplot(3, N, i);       imshow(sdata{i});
    subplot(3, N, i+N);       imshow(xdata{i});
    subplot(3, N, i+N*2);       imshow(soutData{i});
end

