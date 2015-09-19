function [volHeader] = stpReadVolHeader(fin, fileName)
% 这是一个读取segy文件卷头的函数
%
% 输出
% volHeader     返回的卷头结构体
%               它是一个结构体，含有{baseInfo(3200Bytes), lastInfo(400Bytes), 
%               sampInv, sampNum, dataForm, traceNum, sizeTrace}
% 
% 输入
% fileName      代表segy文件路径
% fin           代表打开文件后的句柄

    fileInfo = dir(fullfile(fileName));                 % 获取文件信息
    fileSize = fileInfo.bytes;                          % 获取文件大小

    volHeader.baseInfo = fread(fin, 3200, 'uchar');     % 以ASCLL方式读取3200字节
    volFirst = fread(fin, 3, 'int32');                  % 读取后面400字节的前3个int32型数据(共12字节)
    volLast = fread(fin, (400-12)/2, 'int16');          % 读取后面400字节的最后int16型的数据(共400-12字节)
    volBase = [volFirst; volLast];                      % 合并后面400字节的数据

    volHeader.lastInfo = volBase;
    volHeader.sampInv = volBase(6);                     % 采样间隔(3217~3218字节 单位：us)
    volHeader.sampNum = volBase(8);                     % 采样数量(3221~3222字节 样点数/道数=道长)
    volHeader.dataForm = volBase(10);                   % 数据格式(3225~3226字节 1=4字节IBM浮点数  5=4字节IEEE浮点数)
    volHeader.traceNum = (fileSize - 3600) / (240 + volHeader.sampNum*4);     % 道的数量
    volHeader.sizeTrace = volHeader.sampNum * 4;        % 每个数据的大小是4个字节
end