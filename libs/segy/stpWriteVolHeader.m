function stpWriteVolHeader(fout, volHeader)
% ����һ��д��segy�ļ���ͷ�ĺ���
%
% ���
% ��
%
% ����
% volHeader         ���еľ�ͷ�ṹ��{baseInfo, }
% fout              ������ļ���ľ��
    
    fwrite(fout, volHeader.baseInfo, 'uchar');              % 3200�ֽ�ASCII����
    volHeader.lastInfo(10) = 5;                             % ������ʽ����:1/IBM;5/IEEE
    fwrite(fout, volHeader.lastInfo(1:3), 'int32');         % 400�ֽڶ�����������
    fwrite(fout, volHeader.lastInfo(4:end), 'int16');         
end
