function [offsetMin, offsetMax, superTrData] = stpCalcSuperChannelSet(inFileName, superTrNum, inIds, crossIds)
% ����һ�����㳬�����ĺ���
%
% ���
% ��
%
% ����
% inFileName        �Ƕ�ȡ�ĵ�ǰsegy�ļ�·��
% superTrNum        �Ƕ��ڹ������ĵ�ǰ�������ϳ�Ϊ���ٵ�������
% inIds             ����ĵ�����inline
% crossIds          ����ĵ�����crossline ��inline��crosslineά��һ����

    %% 
    % ��ȡ������ ����������Ϣ
    fin = fopen(inFileName, 'r', 'ieee-be');                % ��IEEE��ʽ���ļ�
    volHeader = stpReadVolHeader(fin, inFileName);             % ��ȡ��ͷ

    %% 
    % ��һ�γ�����Ϊ�˼�����ڼ��ķ�Χ
    trHeader = stpReadTraceHeader(fin);                        % ��ȡ��һ����ͷ

    offsetMax = trHeader.offset;
    offsetMin = trHeader.offset;
    inId = trHeader.inId;
    crossId = trHeader.crossId;

    fseek(fin, volHeader.sizeTrace, 0);                     % ������������
    while (true)
        trHeader = stpReadTraceHeader(fin);                    % ��ȡ��ͷ

        % ������ǵ�ǰ����������ѭ�� 
        if (trHeader.inId ~= inId || trHeader.crossId ~= crossId)  
            break;
        end

        % �޸������Сֵ
        if(trHeader.offset > offsetMax) 
            offsetMax = trHeader.offset;
        end
        if(trHeader.offset < offsetMin)
            offsetMin = trHeader.offset;
        end

        fseek(fin, volHeader.sizeTrace, 0);                 % ����������һ������������������
    end

    % ׼����ȡ������
    if (fseek(fin, 3600, -1) == -1)                         % �����ļ�ָ�뵽��һ����ʼλ��
        fprintf('�ļ�ָ����ת����һ������');
    end
    
    invOffset = (offsetMax-offsetMin) / superTrNum;         % ���������ڼ����
    % �����������(���ߵĵ���)
    [~, pointNum] = size(inIds);
    superTrData = zeros(volHeader.sampNum, pointNum * superTrNum);

    % ��ȡ����
    % ������
    title = '����ת����ǰ����Ϊ������...';
    hwait = waitbar(0, title);
    step = pointNum / 100;
    superNum = zeros(1, superTrNum);
    
    %%
    % ���������ϵĵ�
    for i = 1 : pointNum
        strShow = ['�����', num2str(i/step, '%.2f'), '%'];
        waitbar(i/pointNum, hwait, strShow);
            
        inId = inIds(i);
        crossId = crossIds(i);
        lastTrace = false;                          % �����ж��Ƿ������һ��
        startPos = (i-1)*superTrNum;

        % ���ú����������inId�͵���crossId����ʼ��λ�ã�
        index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId);
        if(index == -1)
            fprintf('���ļ���δ�ҵ�����inline=%d��cossline=%d�ĵ�\n', inId, crossId);
            continue;
        end
        
        % ������ǰ·����
        fseek(fin, 3600 + (index-1)*(240+volHeader.sizeTrace), -1);
        
        % ����һ������
        while (true)
            if lastTrace ~= true
                trHeader = stpReadTraceHeader(fin);                                         % ��ȡ��ͷ
                data = stpReadTraceData(fin, volHeader.sampNum, volHeader.dataForm);        % ��ȡ����
                index = index + 1;
            end
            
            % ������ǵ�ǰ����������ѭ�� 
            if (trHeader.inId ~= inId || trHeader.crossId ~= crossId || lastTrace == true)  
                inId = trHeader.inId;
                crossId = trHeader.crossId;

                % ƽ����������
                for j = 1 : superTrNum
                    superTrData(:, startPos + j) = superTrData(:, startPos + j) / superNum(j);
                end
                
                superNum(:) = 0;
                break;
            end
            
            % ��������������ڵڼ���
            superTraceId = (trHeader.offset-offsetMin) / invOffset;
            superTraceId = floor(superTraceId) + 1;
            if(superTraceId > superTrNum)
                superTraceId = superTrNum;
            end

            % ���Ӵ���ͬһ��������������
            superTrData(:, startPos + superTraceId) = superTrData(:, startPos + superTraceId) + data; 
            superNum(superTraceId) = superNum(superTraceId) + 1;

            if index > volHeader.traceNum
                lastTrace = true;
            end
        end
    end
    
    close(hwait);
    % �رմ��ļ�
    fclose(fin);                                        % ��ȡ���֮����Ҫ�ر�fin
    
    % %%
    % %���Ƶ�������
%     seismic = s_convert(superTrData, 0, 2);
%     s_wplot(seismic);
%     title('���泬��������');
end