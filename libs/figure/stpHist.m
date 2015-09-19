function [bb] = stpHist(vec, color)
%% ����ֱ��ͼ��ֻ�ǻ��ƶ��������ߣ����ڲ鿴�ֲ�

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