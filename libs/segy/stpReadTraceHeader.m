function [traceHeader] = stpReadTraceHeader(fin)
% 这是一个读取道头的程序
%
% 输出
% traceHeader   代表读取的道头
%               它是一个结构体，包含了 {fullInfo, inId, crossId, offset}等信息
% 
% 输入
% fin           打开文件后的句柄

    %fullInfo = fread(fin, 60, 'int32');                     % 读取当前道的240字节道头

    traceHeader.fullInfo = fread(fin, 60, 'int32');                     % 把道头的全部信息存到输出的结构体里面
    traceHeader.inId = traceHeader.fullInfo(3, 1);                      % 读取inline号
    traceHeader.crossId = traceHeader.fullInfo(6, 1);                   % 读取crossline号
    traceHeader.offset = traceHeader.fullInfo(10, 1);                   % 读取炮检距信息
end