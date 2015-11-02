function stpPlotParabola( a, b, c, sp, color)
%% ���ƶ������ߵĺ���
    x = min(sp(:, 1)) : 0.1 : max(sp(:, 1));
    y = a * x .* x + b * x + c;
    plot(x, y, str);
    plot(sp(:, 1), sp(:, 2), [color, '*']);
end

