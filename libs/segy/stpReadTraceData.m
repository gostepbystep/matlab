function [traceData] = stpReadTraceData(fin, sampNum, dataFormat)
% ����һ����ȡһ�����ݵĳ���
%
% ���
% traceData     ��ȡ������һ�� sampNum*1������
%
% ����
% fin           �Ǵ��ļ���ľ��
% sampNum       �ǲ�������
% dataFormat    �����ݸ�ʽ

    % ��ȡ�õ��Ĳ�������
    if dataFormat == 1                                          % IBM��������ȡ
        traceData = fread(fin, sampNum, 'uint32=>uint32');      % ������sgy_IBM��ʽ
        traceData = ibm2double(traceData);                      % IBM_To_Double
    elseif dataFormat == 5                                      % IEEE��������ȡ
        traceData = fread(fin, sampNum, 'float32');             % ��ȡIEEE����
    end
end