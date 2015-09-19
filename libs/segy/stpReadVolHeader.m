function [volHeader] = stpReadVolHeader(fin, fileName)
% ����һ����ȡsegy�ļ���ͷ�ĺ���
%
% ���
% volHeader     ���صľ�ͷ�ṹ��
%               ����һ���ṹ�壬����{baseInfo(3200Bytes), lastInfo(400Bytes), 
%               sampInv, sampNum, dataForm, traceNum, sizeTrace}
% 
% ����
% fileName      ����segy�ļ�·��
% fin           ������ļ���ľ��

    fileInfo = dir(fullfile(fileName));                 % ��ȡ�ļ���Ϣ
    fileSize = fileInfo.bytes;                          % ��ȡ�ļ���С

    volHeader.baseInfo = fread(fin, 3200, 'uchar');     % ��ASCLL��ʽ��ȡ3200�ֽ�
    volFirst = fread(fin, 3, 'int32');                  % ��ȡ����400�ֽڵ�ǰ3��int32������(��12�ֽ�)
    volLast = fread(fin, (400-12)/2, 'int16');          % ��ȡ����400�ֽڵ����int16�͵�����(��400-12�ֽ�)
    volBase = [volFirst; volLast];                      % �ϲ�����400�ֽڵ�����

    volHeader.lastInfo = volBase;
    volHeader.sampInv = volBase(6);                     % �������(3217~3218�ֽ� ��λ��us)
    volHeader.sampNum = volBase(8);                     % ��������(3221~3222�ֽ� ������/����=����)
    volHeader.dataForm = volBase(10);                   % ���ݸ�ʽ(3225~3226�ֽ� 1=4�ֽ�IBM������  5=4�ֽ�IEEE������)
    volHeader.traceNum = (fileSize - 3600) / (240 + volHeader.sampNum*4);     % ��������
    volHeader.sizeTrace = volHeader.sampNum * 4;        % ÿ�����ݵĴ�С��4���ֽ�
end