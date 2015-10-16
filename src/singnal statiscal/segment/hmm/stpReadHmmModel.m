function [stateNum, probStart, probTrans, probEmit] = stpReadHmmModel( fileName )
%% ����һ����ȡHmmģ�͵ĺ���
%
%% ����
% fileName �ļ�·��
%
%% ���
% probStart ��ʼ�ܶ�
% probTrans ת�ƾ���
% probEmit  �������Ҳ���Խ�����������

    % ���ļ�
    fin = fopen(fileName, 'r');
    
    step = 1;
    lines = 0;
    k = 1;
 
    
    % ѭ����ÿ�ζ�ȡһ������
    while (true)
        lines = lines + 1;
        str = fgetl(fin);
        
        if ~ischar(str)
            break 
        end;
        
        if strcmp(str, '') || strncmp(str, '#', 1)
            continue;
        else
            % ������� # �ſ�ͷ
            if step == 1
                % ��ȡ���ݸ���
                info = textscan(str, '%d');
                stateNum = info{1};
                probEmit = cell(1, stateNum);
            elseif step == 2
                % ��ȡ��ʼ����
                formats = repmat(' %f', 1, stateNum);
                fseek(fin, 0, -1);
                info = textscan(fin, formats, 'HeaderLines', lines-1); 
                probStart = cell2mat(info);
                
            elseif step == 3
                % ��ȡת������
                formats = repmat(' %f', 1, stateNum);
                fseek(fin, 0, -1);
                info = textscan(fin, formats, stateNum, 'HeaderLines', lines-1); 
                probTrans = cell2mat(info);
                lines = lines + stateNum - 1;
                
            else
                % ��ȡ�������
                data = regexp(str, ',', 'split');
                map = containers.Map();
                
                for i = 1 : length(data)
                    stri = data{i};
                    item = regexp(stri, ':', 'split');
                    map(item{1}) = item{2};
                end
                
                probEmit{k} = map;
                k = k + 1;
            end
        end
        step = step + 1;
        
        
    end
    
end

