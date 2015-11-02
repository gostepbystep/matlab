%% 颜色空间的对比图
clc;
close all;
clear;

imgdata = imread('data\\10.jpg');

rgbdata = 255 * im2double(imgdata);
labdata = stpRgb2Lab(imgdata);

figure;
imshow(imgdata);
title('彩色图像');

[m, n, ~] = size(rgbdata);
N = 1000;
rgbd = reshape(rgbdata, m*n, 3);
labd = reshape(labdata, m*n, 3);
labd(:, 1) = labd(:, 1) - 50;

rgbdata = zeros(N, 3);
labdata = zeros(N, 3);

for i = 1 : N
    index = floor(m*n*rand());
    
    rgbdata(i, :) = rgbd(index, :);
    labdata(i, :) = labd(index, :);
end




%% rgb
figure;
%  plot3(labdata(:, :, 1), labdata(:, :, 2), labdata(:, :, 3), 'b*');
subplot(2, 3, 1);
plot(rgbdata(:, 1), rgbdata( :, 2), 'ro');
xlabel('R'); ylabel('G');
title('red-green');

subplot(2, 3, 2);
hold on; plot(rgbdata(:, 1), rgbdata(:, 3), 'ro');
xlabel('R'); ylabel('B');
title('red-blue');

subplot(2, 3, 3);
hold on; plot(rgbdata(:, 2), rgbdata(:, 3), 'ro');
xlabel('G'); ylabel('B');
title('green-blue');

%% lab
%  plot3(labdata(:, :, 1), labdata(:, :, 2), labdata(:, :, 3), 'b*');
subplot(2, 3, 4);
hold on; plot(labdata(:, 1), labdata(:, 2), 'b*');
xlabel('L'); ylabel('a');
axis([-50 50 -50 50]);
title('L-a');

subplot(2, 3, 5);
hold on; plot(labdata(:, 1), labdata(:, 3), 'b*');
xlabel('L'); ylabel('b');
axis([-50 50 -50 50]);
title('L-b');

subplot(2, 3, 6);
hold on; plot(labdata( :, 2), labdata(:, 3), 'b*');
xlabel('a'); ylabel('b');
axis([-50 50 -50 50]);
title('a-b');