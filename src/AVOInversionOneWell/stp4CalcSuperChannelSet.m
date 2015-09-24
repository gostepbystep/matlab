function [superTrData, offsetMin, offsetMax] = stp4CalcSuperChannelSet(inFileName, superTrNum, inId, crossId)
% 这是一个计算超道集的函数
%
% 输出
% superTrData       合成的超道集
%
% 输入
% inFileName        是读取的叠前segy文件路劲
% superTrNum        是对于共反射点的叠前道集，合成为多少道超道集
% calcSetNum        是计算多少个反射点的超道集，当其值为-1的时候表示计算全部的叠前道集
%
% 范例
% stpCalcSuperChannelSet('E:\苏里格\new_erwu_Prestack.sgy', 'E:\苏里格\new_erwu_Prestack_out_super.sgy', 10, 10);

    disp('正在合成超道集...');

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

    %%

    invOffset = (offsetMax-offsetMin) / superTrNum;         % 超道集的炮检距间隔

    superTrData = zeros(volHeader.sampNum, superTrNum);
    cpTraceNum = 0;

    % 提取道集
    calcDoneNum = 0;
    % 进度条
    nloop = volHeader.traceNum+1;
    superNum = zeros(1, superTrNum);

    % 调用函数计算等于inId和等于crossId的起始道位置，
    index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId);
    % 跳到当前路径来
    if ( fseek(fin, 3600 + (index-1)*(240+volHeader.sizeTrace), -1) == -1 )
        fprintf('文件指针跳转到指定道错误');
    end
    
    traceData = zeros(volHeader.sampNum, 0);

    for i = 1  : nloop
        if i ~= nloop
            trHeader = stpReadTraceHeader(fin);
            data = stpReadTraceData(fin, volHeader.sampNum, volHeader.dataForm);
        end

        % 如果不是同一个反射点 或者是最后一道了
        if(trHeader.crossId~=crossId || trHeader.inId~=inId || i==nloop)
            inId = trHeader.inId;
            crossId = trHeader.crossId;

            % 平均到超道集
            for j = 1 : superTrNum
                superTrData(:, j) = superTrData(:, j) / superNum(j);
            end
            break;
        end

        % 计算出超道集处于第几道
        superTraceId = (trHeader.offset-offsetMin) / invOffset;
        superTraceId = floor(superTraceId) + 1;

        if(superTraceId > superTrNum)
            superTraceId = superTrNum;
        end

        % 叠加处于同一个超道集的数据
        superTrData(:, superTraceId) = superTrData(:, superTraceId) + data; 
        traceData = [traceData(:, :), data];

        superNum(superTraceId) = superNum(superTraceId) + 1;
        cpTraceNum = cpTraceNum + 1;
    end

    
    % %%
    % %绘制地震数据
    seismic= s_convert(superTrData, 0, 2);
    s_wplot(seismic);
    title('超道集');

    seismic= s_convert(traceData, 0, 2);
    s_wplot(seismic);
    title('原始道集');

    % 关闭打开文件
    fclose(fin);                                        % 读取完毕之后需要关闭fin

end