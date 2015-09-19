function [index] = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId)
% �������ʽΪ�˶�fin������򿪵�segy�ļ����ҵ�inline=inId��stpRossline=crossId�ĵ�����ʼλ��
% ע��������segy�ļ���ŷ�ʽ����stpRossline��inline����inline�Ǹ�ά�ȵ�
%
% ���
% index     �ҵ�����ʼ��������λ�� Ϊ-1��ʱ���ʾû���ҵ�
%
% ����
% fin       �ļ����
% inId      inline��
% crossId   stpRossline��

    fseek(fin, 3600, -1);       % ���ļ�ͷ��ʼ����3600�ֽ�
    % ʹ�ö��ַ�����
    startPos = 1;
    endPos = volHeader.traceNum;
    index = floor((startPos+endPos) / 2);

    sizeTrace = volHeader.sizeTrace+240;        % ����ÿһ���Ĵ�С

    while(startPos~=index && index~=endPos)
        % �޸�index
        index = floor((startPos+endPos) / 2);

        offset = 3600 + sizeTrace*(index-1);    % �ļ�����Ҫ�������ֽ���
        fseek(fin, offset, -1);                 % ���ļ���ʼ����
        trHeader = stpReadTraceHeader(fin);    % ��ȡ��ǰ��������

        % ��inline �� stpRossline
        if( trHeader.inId > inId)
            % ���ˣ��������
            endPos = index - 1;
        elseif( trHeader.inId < inId)
            startPos = index + 1;
        else 
            if(trHeader.crossId > crossId)
                endPos = index - 1;
            elseif(trHeader.crossId < crossId)
                startPos = index + 1;
            else
                break;
            end
        end
    end

    if(trHeader.inId ~= inId || trHeader.crossId ~= crossId)
        % ˵��û���ҵ�
        index = -1;
    else
        % ˵���ҵ��ˣ���ô�ӵ�ǰλ��һֱ��ǰ�ң�ֱ���õ���һ�����Ǻϵ�λ��
        fseek(fin, 3600+sizeTrace*(index-1), -1);

        while(true)
            trHeader = stpReadTraceHeader(fin);    % ��ȡ��ǰ��������
            if(trHeader.crossId==crossId && trHeader.inId==inId)
                index = index - 1;
                if( index == 0)
                    break;
                else
                    % �˴�Ҫע�⣬��Ϊ֮ǰ��ȡ�˵�ͷ��������Ҫ��ȥ240�ֽ���ǰ��
                    fseek(fin, -sizeTrace-240, 0);
                end
            else
                break;
            end
        end
        
        index = index + 1;
    end
end