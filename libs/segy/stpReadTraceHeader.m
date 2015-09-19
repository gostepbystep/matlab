function [traceHeader] = stpReadTraceHeader(fin)
% ����һ����ȡ��ͷ�ĳ���
%
% ���
% traceHeader   �����ȡ�ĵ�ͷ
%               ����һ���ṹ�壬������ {fullInfo, inId, crossId, offset}����Ϣ
% 
% ����
% fin           ���ļ���ľ��

    %fullInfo = fread(fin, 60, 'int32');                     % ��ȡ��ǰ����240�ֽڵ�ͷ

    traceHeader.fullInfo = fread(fin, 60, 'int32');                     % �ѵ�ͷ��ȫ����Ϣ�浽����Ľṹ������
    traceHeader.inId = traceHeader.fullInfo(3, 1);                      % ��ȡinline��
    traceHeader.crossId = traceHeader.fullInfo(6, 1);                   % ��ȡcrossline��
    traceHeader.offset = traceHeader.fullInfo(10, 1);                   % ��ȡ�ڼ����Ϣ
end