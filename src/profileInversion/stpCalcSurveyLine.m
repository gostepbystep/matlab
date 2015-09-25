function [outInIds, outCrossIds] = stpCalcSurveyLine(inIds, crossIds, wellNames, firstCdp, traceNum)
% 这是一个计算测线的函数
%
% 输出
% outInIds              输出的inline
% outCrossIds           输出的crossline
%
% 输入
% inIds                 输入的inline
% crossIds              输入的crossline
% firstCdp              第一个crossline号
% traceNum              测线的道数

    endCdp = firstCdp + traceNum - 1;
    
%     setInIds = [2900, inIds, inIds(length(inIds))];
%     setInIds = [inIds(1), inIds, inIds(length(inIds))];
    setInIds = [2750, inIds, 2750];
    setCrossIds = [firstCdp, crossIds, endCdp];
    
    outCrossIds = firstCdp : 1 : endCdp;
    outInIds = stpCubicSpline(setCrossIds, setInIds, outCrossIds, 0, 0);

    % 向下取整
    for i = 1 : length(outInIds)
        outInIds(i) = floor(outInIds(i));
    end

    figure;
    plot(outCrossIds, outInIds, 'r'); set(gca,'ydir','reverse');
    hold on;
    text(crossIds, inIds, wellNames, 'FontSize', 8);
    set(gca, 'ylim', [2550 2950]);
    xlabel('Crossline','FontSize',14);ylabel('Inline','FontSize',14);
    title('苏里格测线位置曲线', 'FontSize', 18);
end