function [trData] = stp2CalcPoststackOneCRPTrace(fileName, inId, crossId)
% 给定inline和crossline号之后，遍历道集，找出与之相同的道集，对其做叠加，得到一个叠后道集
%
% 输出
% trData    输出叠后的道（纯时间序列的数据）
%
% 输入
% fileName  segy文件名
% inId      inline 给定的需要找到的inline号
% crossId   crossId 给定的需要找到的stpRossline号
%
% 范例
% stpCalcPoststackOneCRPTrace('E:\苏里格\new_erwu_Prestack80.sgy', 2666,1691);
    
    %%
    fin = fopen(fileName, 'r', 'ieee-be');              % 以IEEE方式打开文件
    volHeader = stpReadVolHeader(fin, fileName);          % 读取卷头

    isFind = false;

    % 调用函数计算等于inId和等于crossId的起始道位置，
    index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId);
    if(index == -1)
        fprintf('在文件中未找到符合inline=%d且stpRossline=%d的道\n', inId, crossId);
    end

    %%
    trData = zeros(volHeader.sampNum, 1);
    okTraceNum = 0;
    % 跳到当前路径来
    fseek(fin, 3600 + (index-1)*(240+volHeader.sizeTrace), -1);
    
    % 如果找到了，就继续走下去
    for i = index : volHeader.traceNum
        % 读取道头
        trHeader = stpReadTraceHeader(fin);

        if(trHeader.inId==inId && trHeader.crossId==crossId)
            isFind = true;
            okTraceNum = okTraceNum + 1;
            
            % 读取数据并累加
            data = stpReadTraceData(fin, volHeader.sampNum, volHeader.dataForm);
            trData = trData + data;
            
            if i ~= volHeader.traceNum
                continue;
            end
        elseif(isFind == true || i == volHeader.traceNum)
            % 表示已经遍历完所有的该反射点的道
            trData = trData / okTraceNum;
            break;
        end

        fseek(fin, volHeader.sizeTrace, 0);                       
    end

    %%
    % 绘制地震数据
%     seismic= s_convert(trData, 0, 2);
%     s_wplot(seismic);
%     title('叠后地震记录');

    %%
    fclose(fin);                                        % 读取完毕之后需要关闭fin
end