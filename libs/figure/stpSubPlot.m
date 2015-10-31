function stpSubPlot( M, N, index)
% �����յ���ʾ
    w = 1.0/N; h = 1.0/M;
    wi = 0.9*w; hi = 0.9*h;
    
    [x,y] = ind2sub([M, N], index);
    subplot('Position', [(x-1)*w 1-y*h wi hi]);
end

