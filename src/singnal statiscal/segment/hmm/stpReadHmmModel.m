function [stateNum, probStart, probTrans, probEmit] = stpReadHmmModel( fileName )
%% 这是一个读取Hmm模型的函数
%
%% 输入
% fileName 文件路径
%
%% 输出
% probStart 初始密度
% probTrans 转移矩阵
% probEmit  发射矩阵（也可以叫做混淆矩阵）

    % 打开文件
    fin = fopen(fileName, 'r');
    
    step = 1;
    lines = 0;
    k = 1;
 
    
    % 循环，每次读取一行数据
    while (true)
        lines = lines + 1;
        str = fgetl(fin);
        
        if ~ischar(str)
            break 
        end;
        
        if strcmp(str, '') || strncmp(str, '#', 1)
            continue;
        else
            % 如果不是 # 号开头
            if step == 1
                % 读取数据个数
                info = textscan(str, '%d');
                stateNum = info{1};
                probEmit = cell(1, stateNum);
            elseif step == 2
                % 读取初始概率
                formats = repmat(' %f', 1, stateNum);
                fseek(fin, 0, -1);
                info = textscan(fin, formats, 'HeaderLines', lines-1); 
                probStart = cell2mat(info);
                
            elseif step == 3
                % 读取转换矩阵
                formats = repmat(' %f', 1, stateNum);
                fseek(fin, 0, -1);
                info = textscan(fin, formats, stateNum, 'HeaderLines', lines-1); 
                probTrans = cell2mat(info);
                lines = lines + stateNum - 1;
                
            else
                % 读取发射矩阵
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

