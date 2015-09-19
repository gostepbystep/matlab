function stpWriteTrace(fout, traceHeader, data)
% 这是一个写入一道数据的程序
%
% 输出
% 无
%
% 输入
% fout          打开写入文件的句柄
% traceHeader   道头
% data          数据

    fwrite(fout, traceHeader.fullInfo, 'int32');
    fwrite(fout, data, 'float32');
end