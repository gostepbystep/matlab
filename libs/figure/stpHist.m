function [bb] = stpHist(vec, color)
%% 绘制直方图，只是绘制顶部的曲线，用于查看分布

n = length(vec);

n = floor(n / 50);

bb =  hist(vec, n);

% h = findobj(gca, 'Type', 'pathch');
% set(h, 'FaceColor', color, 'EdgeColor', 'w');

x = linspace(min(vec), max(vec), n);

% x = 1 : n;
% x = x - floor(n/2);

plot(x, bb, color);

end