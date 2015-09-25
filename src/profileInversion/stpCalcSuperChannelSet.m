function [offsetMin, offsetMax, superTrData] = stpCalcSuperChannelSet(inFileName, superTrNum, inIds, crossIds)
% 这是一个计算超道集的函数
%
% 输出
% 无
%
% 输入
% inFileName        是读取的叠前segy文件路劲
% superTrNum        是对于共反射点的叠前道集，合成为多少道超道集
% inIds             计算的道集的inline
% crossIds          计算的道集的crossline （inline和crossline维度一样）

    %% 
    % 读取超道集 道集基本信息
    fin = fopen(inFileName, 'r', 'ieee-be');                % 以IEEE方式打开文件
    volHeader = stpReadVolHeader(fin, inFileName);             % 读取卷头

    %% 
    % 这一段程序是为了计算出炮检距的范围
    trHeader = stpReadTraceHeader(fin);                        % 读取第一道道头

    offsetMax = trHeader.offset;
    offsetMin = trHeader.offset;
    inId = trHeader.inId;
    crossId = trHeader.crossId;

    fseek(fin, volHeader.sizeTrace, 0);                     % 跳过采样数据
    while (true)
        trHeader = stpReadTraceHeader(fin);                    % 读取道头

        % 如果不是当前反射点就跳出循环 
        if (trHeader.inId ~= inId || trHeader.crossId ~= crossId)  
            break;
        end

        % 修改最大最小值
        if(trHeader.offset > offsetMax) 
            offsetMax = trHeader.offset;
        end
        if(trHeader.offset < offsetMin)
            offsetMin = trHeader.offset;
        end

        fseek(fin, volHeader.sizeTrace, 0);                 % 如果不是最后一道，就跳过采样数据
    end

    % 准备提取超道集
    if (fseek(fin, 3600, -1) == -1)                         % 设置文件指针到第一道开始位置
        fprintf('文件指针跳转到第一道错误');
    end
    
    invOffset = (offsetMax-offsetMin) / superTrNum;         % 超道集的炮检距间隔
    % 计算道集数量(测线的点数)
    [~, pointNum] = size(inIds);
    superTrData = zeros(volHeader.sampNum, pointNum * superTrNum);

    % 提取道集
    % 进度条
    title = '正在转换叠前道集为超道集...';
    hwait = waitbar(0, title);
    step = pointNum / 100;
    superNum = zeros(1, superTrNum);
    
    %%
    % 遍历测线上的点
    for i = 1 : pointNum
        strShow = ['已完成', num2str(i/step, '%.2f'), '%'];
        waitbar(i/pointNum, hwait, strShow);
            
        inId = inIds(i);
        crossId = crossIds(i);
        lastTrace = false;                          % 用于判断是否是最后一道
        startPos = (i-1)*superTrNum;

        % 调用函数计算等于inId和等于crossId的起始道位置，
        index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId);
        if(index == -1)
            fprintf('在文件中未找到符合inline=%d且cossline=%d的道\n', inId, crossId);
            continue;
        end
        
        % 跳到当前路径来
        fseek(fin, 3600 + (index-1)*(240+volHeader.sizeTrace), -1);
        
        % 处理一个道集
        while (true)
            if lastTrace ~= true
                trHeader = stpReadTraceHeader(fin);                                         % 读取道头
                data = stpReadTraceData(fin, volHeader.sampNum, volHeader.dataForm);        % 读取数据
                index = index + 1;
            end
            
            % 如果不是当前反射点就跳出循环 
            if (trHeader.inId ~= inId || trHeader.crossId ~= crossId || lastTrace == true)  
                inId = trHeader.inId;
                crossId = trHeader.crossId;

                % 平均到超道集
                for j = 1 : superTrNum
                    superTrData(:, startPos + j) = superTrData(:, startPos + j) / superNum(j);
                end
                
                superNum(:) = 0;
                break;
            end
            
            % 计算出超道集处于第几道
            superTraceId = (trHeader.offset-offsetMin) / invOffset;
            superTraceId = floor(superTraceId) + 1;
            if(superTraceId > superTrNum)
                superTraceId = superTrNum;
            end

            % 叠加处于同一个超道集的数据
            superTrData(:, startPos + superTraceId) = superTrData(:, startPos + superTraceId) + data; 
            superNum(superTraceId) = superNum(superTraceId) + 1;

            if index > volHeader.traceNum
                lastTrace = true;
            end
        end
    end
    
    close(hwait);
    % 关闭打开文件
    fclose(fin);                                        % 读取完毕之后需要关闭fin
    
    % %%
    % %绘制地震数据
%     seismic = s_convert(superTrData, 0, 2);
%     s_wplot(seismic);
%     title('剖面超道集数据');
end