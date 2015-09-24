function [superTrData, offsetMin, offsetMax] = stp4CalcSuperChannelSet(inFileName, superTrNum, inId, crossId)
% ����һ�����㳬�����ĺ���
%
% ���
% superTrData       �ϳɵĳ�����
%
% ����
% inFileName        �Ƕ�ȡ�ĵ�ǰsegy�ļ�·��
% superTrNum        �Ƕ��ڹ������ĵ�ǰ�������ϳ�Ϊ���ٵ�������
% calcSetNum        �Ǽ�����ٸ������ĳ�����������ֵΪ-1��ʱ���ʾ����ȫ���ĵ�ǰ����
%
% ����
% stpCalcSuperChannelSet('E:\�����\new_erwu_Prestack.sgy', 'E:\�����\new_erwu_Prestack_out_super.sgy', 10, 10);

    disp('���ںϳɳ�����...');

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

    %%

    invOffset = (offsetMax-offsetMin) / superTrNum;         % ���������ڼ����

    superTrData = zeros(volHeader.sampNum, superTrNum);
    cpTraceNum = 0;

    % ��ȡ����
    calcDoneNum = 0;
    % ������
    nloop = volHeader.traceNum+1;
    superNum = zeros(1, superTrNum);

    % ���ú����������inId�͵���crossId����ʼ��λ�ã�
    index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId);
    % ������ǰ·����
    if ( fseek(fin, 3600 + (index-1)*(240+volHeader.sizeTrace), -1) == -1 )
        fprintf('�ļ�ָ����ת��ָ��������');
    end
    
    traceData = zeros(volHeader.sampNum, 0);

    for i = 1  : nloop
        if i ~= nloop
            trHeader = stpReadTraceHeader(fin);
            data = stpReadTraceData(fin, volHeader.sampNum, volHeader.dataForm);
        end

        % �������ͬһ������� ���������һ����
        if(trHeader.crossId~=crossId || trHeader.inId~=inId || i==nloop)
            inId = trHeader.inId;
            crossId = trHeader.crossId;

            % ƽ����������
            for j = 1 : superTrNum
                superTrData(:, j) = superTrData(:, j) / superNum(j);
            end
            break;
        end

        % ��������������ڵڼ���
        superTraceId = (trHeader.offset-offsetMin) / invOffset;
        superTraceId = floor(superTraceId) + 1;

        if(superTraceId > superTrNum)
            superTraceId = superTrNum;
        end

        % ���Ӵ���ͬһ��������������
        superTrData(:, superTraceId) = superTrData(:, superTraceId) + data; 
        traceData = [traceData(:, :), data];

        superNum(superTraceId) = superNum(superTraceId) + 1;
        cpTraceNum = cpTraceNum + 1;
    end

    
    % %%
    % %���Ƶ�������
    seismic= s_convert(superTrData, 0, 2);
    s_wplot(seismic);
    title('������');

    seismic= s_convert(traceData, 0, 2);
    s_wplot(seismic);
    title('ԭʼ����');

    % �رմ��ļ�
    fclose(fin);                                        % ��ȡ���֮����Ҫ�ر�fin

end