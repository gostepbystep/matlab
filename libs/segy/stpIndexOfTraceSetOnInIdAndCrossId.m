function [index] = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId)
% 这个函数式为了对fin句柄所打开的segy文件中找到inline=inId且stpRossline=crossId的道的起始位置
% 注意的是这个segy文件存放方式是先stpRossline后inline，即inline是高维度的
%
% 输出
% index     找到的起始道的索引位置 为-1的时候表示没有找到
%
% 输入
% fin       文件句柄
% inId      inline号
% crossId   stpRossline号

    fseek(fin, 3600, -1);       % 从文件头开始跳过3600字节
    % 使用二分法查找
    startPos = 1;
    endPos = volHeader.traceNum;
    index = floor((startPos+endPos) / 2);

    sizeTrace = volHeader.sizeTrace+240;        % 完整每一道的大小

    while(startPos~=index && index~=endPos)
        % 修改index
        index = floor((startPos+endPos) / 2);

        offset = 3600 + sizeTrace*(index-1);    % 文件中需要跳过的字节数
        fseek(fin, offset, -1);                 % 从文件开始跳过
        trHeader = stpReadTraceHeader(fin);    % 读取当前道的数据

        % 先inline 后 stpRossline
        if( trHeader.inId > inId)
            % 大了，就在左边
            endPos = index - 1;
        elseif( trHeader.inId < inId)
            startPos = index + 1;
        else 
            if(trHeader.crossId > crossId)
                endPos = index - 1;
            elseif(trHeader.crossId < crossId)
                startPos = index + 1;
            else
                break;
            end
        end
    end

    if(trHeader.inId ~= inId || trHeader.crossId ~= crossId)
        % 说明没有找到
        index = -1;
    else
        % 说明找到了，那么从当前位置一直向前找，直到得到第一个道吻合的位置
        fseek(fin, 3600+sizeTrace*(index-1), -1);

        while(true)
            trHeader = stpReadTraceHeader(fin);    % 读取当前道的数据
            if(trHeader.crossId==crossId && trHeader.inId==inId)
                index = index - 1;
                if( index == 0)
                    break;
                else
                    % 此处要注意，因为之前读取了道头，所以需要减去240字节向前读
                    fseek(fin, -sizeTrace-240, 0);
                end
            else
                break;
            end
        end
        
        index = index + 1;
    end
end