function [timeLine] = stpCalcTimeLine(path, inIds, crossIds, firstCdp)
% 计算目的层时间线的函数
    [~, cdpNum] = size(inIds);
    timeLine = zeros(1, cdpNum);
    
    % 打开文件
    fin = fopen(path,'r');
    
    num = 0;
    
    while true
        data = textscan(fin, '%f%f%f%d%d%s', 1);
        index = data{4} - firstCdp + 1;
        
        if(index>=1 && index<=cdpNum && data{5}==inIds(index) && data{4}==crossIds(index))
            timeLine(index) = data{3};
            num = num + 1;
        end
            
        if(num == cdpNum)
            break;
        end
        
    end
   
    
    fclose(fin);
    
    figure;
    meanTime = mean(timeLine);
    TX = 1 : 1 : cdpNum;
    plot(TX, meanTime, 'r');
    
    save h8 timeLine;
end
