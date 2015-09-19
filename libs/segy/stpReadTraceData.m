function [traceData] = stpReadTraceData(fin, sampNum, dataFormat)
% 这是一个读取一道数据的程序
%
% 输出
% traceData     读取出来是一个 sampNum*1的向量
%
% 输入
% fin           是打开文件后的句柄
% sampNum       是采样数量
% dataFormat    是数据格式

    % 读取该道的采样数据
    if dataFormat == 1                                          % IBM浮点数读取
        traceData = fread(fin, sampNum, 'uint32=>uint32');      % 适用于sgy_IBM格式
        traceData = ibm2double(traceData);                      % IBM_To_Double
    elseif dataFormat == 5                                      % IEEE浮点数读取
        traceData = fread(fin, sampNum, 'float32');             % 读取IEEE数据
    end
end