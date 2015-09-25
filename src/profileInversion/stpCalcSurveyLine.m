function [outInIds, outCrossIds] = stpCalcSurveyLine(inIds, crossIds, wellNames, firstCdp, traceNum)
% ����һ��������ߵĺ���
%
% ���
% outInIds              �����inline
% outCrossIds           �����crossline
%
% ����
% inIds                 �����inline
% crossIds              �����crossline
% firstCdp              ��һ��crossline��
% traceNum              ���ߵĵ���

    endCdp = firstCdp + traceNum - 1;
    
%     setInIds = [2900, inIds, inIds(length(inIds))];
%     setInIds = [inIds(1), inIds, inIds(length(inIds))];
    setInIds = [2750, inIds, 2750];
    setCrossIds = [firstCdp, crossIds, endCdp];
    
    outCrossIds = firstCdp : 1 : endCdp;
    outInIds = stpCubicSpline(setCrossIds, setInIds, outCrossIds, 0, 0);

    % ����ȡ��
    for i = 1 : length(outInIds)
        outInIds(i) = floor(outInIds(i));
    end

    figure;
    plot(outCrossIds, outInIds, 'r'); set(gca,'ydir','reverse');
    hold on;
    text(crossIds, inIds, wellNames, 'FontSize', 8);
    set(gca, 'ylim', [2550 2950]);
    xlabel('Crossline','FontSize',14);ylabel('Inline','FontSize',14);
    title('��������λ������', 'FontSize', 18);
end