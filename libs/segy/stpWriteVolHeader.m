function stpWriteVolHeader(fout, volHeader)
% 这是一个写入segy文件卷头的函数
%
% 输出
% 无
%
% 输入
% volHeader         已有的卷头结构体{baseInfo, }
% fout              代表打开文件后的句柄
    
    fwrite(fout, volHeader.baseInfo, 'uchar');              % 3200字节ASCII区域
    volHeader.lastInfo(10) = 5;                             % 采样格式编码:1/IBM;5/IEEE
    fwrite(fout, volHeader.lastInfo(1:3), 'int32');         % 400字节二进制数区域
    fwrite(fout, volHeader.lastInfo(4:end), 'int16');         
end
