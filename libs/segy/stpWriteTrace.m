function stpWriteTrace(fout, traceHeader, data)
% ����һ��д��һ�����ݵĳ���
%
% ���
% ��
%
% ����
% fout          ��д���ļ��ľ��
% traceHeader   ��ͷ
% data          ����

    fwrite(fout, traceHeader.fullInfo, 'int32');
    fwrite(fout, data, 'float32');
end