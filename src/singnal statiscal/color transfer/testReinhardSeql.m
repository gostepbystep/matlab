clear;
close all;
clc;

N = 25;
M = 12;

[ otrgb, outImg] = stpReinhardSeq({'data\\7.jpg', ...
    'data\\13.jpg', 'data\\22.jpg'}, 'data\\10.jpg', N, M);

row = 5;
col = 5;

figure;
for i = 1 : row
    for j = 1 : col
        index = j+(i-1)*col;
        stpSubPlot(row, col, index);
        imshow(outImg{index});
        hold on;
    end
end
% subtitle(5, '序列颜色迁移处理');
% 