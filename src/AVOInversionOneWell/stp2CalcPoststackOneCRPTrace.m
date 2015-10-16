function [trData] = stp2CalcPoststackOneCRPTrace(fileName, inId, crossId)
% ����inline��crossline��֮�󣬱����������ҳ���֮��ͬ�ĵ��������������ӣ��õ�һ���������
%
% ���
% trData    �������ĵ�����ʱ�����е����ݣ�
%
% ����
% fileName  segy�ļ���
% inId      inline ��������Ҫ�ҵ���inline��
% crossId   crossId ��������Ҫ�ҵ���stpRossline��
%
% ����
% stpCalcPoststackOneCRPTrace('E:\�����\new_erwu_Prestack80.sgy', 2666,1691);
    
    %%
    fin = fopen(fileName, 'r', 'ieee-be');              % ��IEEE��ʽ���ļ�
    volHeader = stpReadVolHeader(fin, fileName);          % ��ȡ��ͷ

    isFind = false;

    % ���ú����������inId�͵���crossId����ʼ��λ�ã�
    index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId);
    if(index == -1)
        fprintf('���ļ���δ�ҵ�����inline=%d��stpRossline=%d�ĵ�\n', inId, crossId);
    end

    %%
    trData = zeros(volHeader.sampNum, 1);
    okTraceNum = 0;
    % ������ǰ·����
    fseek(fin, 3600 + (index-1)*(240+volHeader.sizeTrace), -1);
    
    % ����ҵ��ˣ��ͼ�������ȥ
    for i = index : volHeader.traceNum
        % ��ȡ��ͷ
        trHeader = stpReadTraceHeader(fin);

        if(trHeader.inId==inId && trHeader.crossId==crossId)
            isFind = true;
            okTraceNum = okTraceNum + 1;
            
            % ��ȡ���ݲ��ۼ�
            data = stpReadTraceData(fin, volHeader.sampNum, volHeader.dataForm);
            trData = trData + data;
            
            if i ~= volHeader.traceNum
                continue;
            end
        elseif(isFind == true || i == volHeader.traceNum)
            % ��ʾ�Ѿ����������еĸ÷����ĵ�
            trData = trData / okTraceNum;
            break;
        end

        fseek(fin, volHeader.sizeTrace, 0);                       
    end

    %%
    % ���Ƶ�������
%     seismic= s_convert(trData, 0, 2);
%     s_wplot(seismic);
%     title('��������¼');

    %%
    fclose(fin);                                        % ��ȡ���֮����Ҫ�ر�fin
end